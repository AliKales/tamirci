import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:tamirci/core/extensions/ext_num.dart';
import 'package:tamirci/core/extensions/ext_object.dart';
import 'package:tamirci/core/local_values.dart';
import 'package:tamirci/core/models/m_extra_cost.dart';
import 'package:tamirci/core/models/m_service.dart';
import 'package:tamirci/locale_keys.dart';
import 'package:tamirci/widgets/buttons.dart';
import 'package:tamirci/widgets/c_text_field.dart';

import '../service_controller.dart';

class PricesView extends StatefulWidget {
  const PricesView(
      {super.key, required this.service, required this.controller});

  final MService service;
  final ServiceController controller;

  @override
  State<PricesView> createState() => _PricesViewState();
}

class _PricesViewState extends State<PricesView>
    with AutomaticKeepAliveClientMixin {
  List<MExtraCost> _extras = [];
  final _tECWorkCost = TextEditingController();
  final _tECPrice = TextEditingController();
  final _tECExplanation = TextEditingController();

  MService get _service => widget.service;

  @override
  void initState() {
    super.initState();
    final c = widget.controller;
    c.receiveService = _receiveService;

    context.afterBuild((p0) => _setValues());
  }

  @override
  void dispose() {
    _tECWorkCost.dispose();
    _tECExplanation.dispose();
    _tECPrice.dispose();
    super.dispose();
  }

  MService _receiveService(MService s) {
    return s.copyWith(
      totalPrice: _totalPrice.amount,
      extraCosts: _extras,
      workCost: _workCost.amount,
    );
  }

  void _setValues() {
    _tECWorkCost.text = widget.service.workCost.toStringNull;
    _extras = widget.service.extraCosts ?? [];
    setState(() {});
  }

  void _onWorkCost(String val) {
    setState(() {});
  }

  void _addExtra() {
    Utils.dismissKeyboard();

    String e = _tECExplanation.textTrim;
    String p = _tECPrice.textTrim;

    if (e.isEmptyOrNull || p.isEmptyOrNull) return;

    final eC = MExtraCost(
      explanation: e,
      price: p.toDouble,
    );

    _extras.add(eC);

    setState(() {});

    _tECExplanation.clear();
    _tECPrice.clear();
  }

  void _removeCost(int i) {
    _extras.removeAt(i);
    setState(() {});
  }

  MoneyFormatter get _totalPrice {
    final fmf = _workCost
        .fastCalc(type: FastCalcType.addition, amount: _getExtrasPrice.amount)
        .fastCalc(type: FastCalcType.addition, amount: _getPiecesPrice.amount);

    return MoneyFormatter(
      amount: fmf.amount,
      settings: MoneyFormatterSettings(
        symbol: "₺",
      ),
    );
  }

  MoneyFormatter get _workCost {
    return MoneyFormatter(amount: _tECWorkCost.textTrim.toDouble);
  }

  MoneyFormatter get _getPiecesPrice {
    final list = _service.usedPieces ?? [];
    var fmf = MoneyFormatter(amount: 0);

    for (var e in list) {
      fmf = fmf.fastCalc(type: FastCalcType.addition, amount: e.price ?? 0);
    }

    return fmf;
  }

  MoneyFormatter get _getExtrasPrice {
    var fmf = MoneyFormatter(amount: 0);

    for (var e in _extras) {
      fmf = fmf.fastCalc(type: FastCalcType.addition, amount: e.price ?? 0);
    }

    return fmf;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: LocalValues.paddingPage(context),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.price,
              style: context.textTheme.titleLarge,
            ),
            Text(
              "${LocaleKeys.total} ${_totalPrice.output.symbolOnRight}",
              style: context.textTheme.titleLarge,
            ),
            CTextField(
              label: LocaleKeys.workCost,
              onChanged: _onWorkCost,
              controller: _tECWorkCost,
              keyboardType: TextInputType.number,
              inputFormatters: LocalValues.moneyFormatters,
            ),
            const Divider(),
            Text(
              LocaleKeys.extraCost,
              style: context.textTheme.titleMedium,
            ),
            CTextField(
              label: LocaleKeys.price,
              controller: _tECPrice,
              inputFormatters: LocalValues.moneyFormatters,
            ),
            CTextField(
              label: LocaleKeys.explanation,
              controller: _tECExplanation,
            ),
            Buttons(context, LocaleKeys.add, _addExtra).filled().centerAlign,
            const Divider(),
            SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return _Card(
                    extraCost: _extras[index],
                    onDelete: () => _removeCost(index),
                  );
                },
                itemCount: _extras.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class _Card extends StatelessWidget {
  const _Card({required this.extraCost, required this.onDelete});

  final MExtraCost extraCost;
  final VoidCallback onDelete;

  String get _text {
    return "${extraCost.explanation}\n${extraCost.price.moneyFormat}";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
        child: Row(
          children: [
            Text(
              _text,
              style: context.textTheme.titleMedium,
            ).expanded,
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_forever),
              iconSize: 30,
              color: context.colorScheme.error,
            ),
          ],
        ),
      ),
    );
  }
}
