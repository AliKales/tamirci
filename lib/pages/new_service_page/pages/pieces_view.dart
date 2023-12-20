import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:tamirci/core/local_values.dart';
import 'package:tamirci/core/models/m_piece.dart';
import 'package:tamirci/core/models/m_service.dart';
import 'package:tamirci/locale_keys.dart';
import 'package:tamirci/widgets/buttons.dart';
import 'package:tamirci/widgets/c_text_field.dart';

class PiecesView extends StatefulWidget {
  const PiecesView(
      {super.key,
      required this.service,
      required this.onAdd,
      required this.onRemove});

  final MService service;
  final ValueChanged<MPiece> onAdd;
  final ValueChanged<int> onRemove;

  @override
  State<PiecesView> createState() => _PiecesViewState();
}

class _PiecesViewState extends State<PiecesView>
    with AutomaticKeepAliveClientMixin {
  final _tECQuantity = TextEditingController(text: "1");
  final _tECPrice = TextEditingController();
  final _tECPiece = TextEditingController();

  final _price = ValueNotifier(0.0);

  List<MPiece> _listPiece = [];

  int get _quantity => _tECQuantity.textTrim.toInt;

  @override
  void initState() {
    super.initState();
    context.afterBuild((p0) => _setPieces());
  }

  @override
  void didUpdateWidget(covariant PiecesView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setPieces();
  }

  void _setPieces() {
    setState(() {
      _listPiece = widget.service.usedPieces ?? [];
    });
  }

  @override
  void dispose() {
    _tECQuantity.dispose();
    _tECPrice.dispose();
    _tECPiece.dispose();
    super.dispose();
  }

  void _addQuantity() {
    int i = _quantity + 1;
    _tECQuantity.text = i.toString();
    _onPriceChange(_tECPrice.textTrim);
  }

  void _removeQuantity() {
    int i = _quantity;
    if (i == 1) return;
    i--;
    _tECQuantity.text = i.toString();
    _onPriceChange(_tECPrice.textTrim);
  }

  void _onPriceChange(String t) {
    _price.value = t.toDouble;
  }

  void _add() {
    if (_tECPrice.isEmpty || _tECPiece.isEmpty) {
      return CustomSnackbar.showSnackBar(
          context: context, text: LocaleKeys.fillAll);
    }

    Utils.dismissKeyboard();

    final p = MPiece(
      piece: _tECPiece.textTrim,
      price: _tECPrice.textTrim.toDouble,
      quantity: _quantity,
    );

    _tECPiece.clear();
    _tECPrice.clear();
    _tECQuantity.text = "1";
    widget.onAdd.call(p);
  }

  void _delete(int i) {
    widget.onRemove.call(i);
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
              LocaleKeys.usedPieces,
              style: context.textTheme.titleLarge,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton.outlined(
                    onPressed: _removeQuantity, icon: const Icon(Icons.remove)),
                CTextField(
                  width: 0.3.toDynamicWidth(context),
                  controller: _tECQuantity,
                  label: LocaleKeys.quantity,
                  readOnly: true,
                ),
                IconButton.outlined(
                    onPressed: _addQuantity, icon: const Icon(Icons.add)),
              ],
            ),
            CTextField(
              label: LocaleKeys.price,
              onChanged: _onPriceChange,
              controller: _tECPrice,
            ),
            ValueListenableBuilder(
              valueListenable: _price,
              builder: (context, val, _) {
                return Text(
                  "${LocaleKeys.totalPrice}: $val",
                  style: context.textTheme.titleMedium,
                );
              },
            ),
            CTextField(
              label: LocaleKeys.usedPiece,
              controller: _tECPiece,
            ),
            Buttons(context, LocaleKeys.add, _add).filled().centerAlign,
            const Divider(),
            SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return _Card(
                    piece: _listPiece[index],
                    onDelete: () => _delete(index),
                  );
                },
                itemCount: _listPiece.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ),
            )
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
  const _Card({
    required this.piece,
    required this.onDelete,
  });

  final MPiece piece;
  final VoidCallback onDelete;

  int get _quantity => piece.quantity!;
  double get _price => piece.price!;
  String get _piece => piece.piece!;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
            child: Text(
              "$_piece\n$_quantity adet\n$_price TL",
              style: context.textTheme.titleLarge!
                  .copyWith(fontWeight: FontWeight.normal),
            ),
          ).expanded,
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_forever),
            color: context.colorScheme.error,
            iconSize: 30,
          ),
        ],
      ),
    );
  }
}
