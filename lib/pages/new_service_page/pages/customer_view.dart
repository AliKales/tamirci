import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tamirci/core/extensions/ext_object.dart';
import 'package:tamirci/core/extensions/ext_string.dart';
import 'package:tamirci/core/local_values.dart';
import 'package:tamirci/core/models/m_customer.dart';
import 'package:tamirci/locale_keys.dart';
import 'package:tamirci/widgets/buttons.dart';
import 'package:tamirci/widgets/c_text_field.dart';

class CustomerViewController {
  MCustomer Function()? receiveCustomer;

  void dispose() {
    receiveCustomer = null;
  }
}

class CustomerView extends StatefulWidget {
  const CustomerView({
    super.key,
    required this.customer,
    required this.controller,
  });

  final MCustomer customer;
  final CustomerViewController controller;

  @override
  State<CustomerView> createState() => _NewCustomerViewState();
}

class _NewCustomerViewState extends State<CustomerView>
    with AutomaticKeepAliveClientMixin {
  final _tECPhone = TextEditingController();
  final _tECCountryCode = TextEditingController();
  final _tECName = TextEditingController();
  final _tECLastName = TextEditingController();
  final _tECIdNo = TextEditingController();
  final _tECTaxNo = TextEditingController();
  final _tECAddress = TextEditingController();

  @override
  void initState() {
    super.initState();

    final controller = widget.controller;

    controller.receiveCustomer = _receiveCustomer;

    context.afterBuild((p0) => _setTextControllers());
  }

  @override
  void dispose() {
    _tECPhone.dispose();
    _tECCountryCode.dispose();
    _tECName.dispose();
    _tECLastName.dispose();
    _tECIdNo.dispose();
    _tECTaxNo.dispose();
    _tECAddress.dispose();
    super.dispose();
  }

  MCustomer _receiveCustomer() {
    return MCustomer(
      name: _tECName.textTrim.toLowerCase(),
      surname: _tECLastName.textTrim.toLowerCase(),
      idNo: _tECIdNo.textTrim.toIntOrNull,
      taxNo: _tECTaxNo.textTrim,
      phone: _tECPhone.textTrim.replaceAll("-", "").toIntOrNull,
      phoneCountryCode: _tECCountryCode.textTrim.toIntOrNull,
      address: _tECAddress.textTrim,
    );
  }

  void _setTextControllers() {
    _tECPhone.text = widget.customer.phone.toStringNull;
    _tECCountryCode.text = widget.customer.phoneCountryCode.toStringNull;
    _tECName.text = widget.customer.name.toStringNull;
    _tECLastName.text = widget.customer.surname.toStringNull;
    _tECIdNo.text = widget.customer.idNo.toStringNull;
    _tECTaxNo.text = widget.customer.taxNo.toStringNull;
    _tECAddress.text = widget.customer.address.toStringNull;
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
              LocaleKeys.customer,
              style: context.textTheme.titleLarge,
            ),
            Row(
              children: [
                SizedBox(
                  width: 0.2.toDynamicWidth(context),
                  child: CTextField(
                    label: LocaleKeys.countryCode,
                    controller: _tECCountryCode,
                    prefixText: "+",
                    length: 3,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                  ),
                ),
                context.sizedBox(width: Values.paddingWidthSmallX),
                CTextField(
                  label: LocaleKeys.phone,
                  controller: _tECPhone,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    CPhoneFormatter(_tECCountryCode.textTrim),
                  ],
                  keyboardType: TextInputType.number,
                ).expanded,
              ],
            ),
            CTextField(
              label: LocaleKeys.idNo,
              controller: _tECIdNo,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              length: 11,
            ),
            CTextField(
              label: LocaleKeys.taxNo,
              controller: _tECTaxNo,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
              ],
              length: 10,
            ),
            Buttons(context, LocaleKeys.findCustomer, () {})
                .filled()
                .centerAlign,
            CTextField(
              label: LocaleKeys.name,
              controller: _tECName,
            ),
            CTextField(
              label: LocaleKeys.lastName,
              controller: _tECLastName,
            ),
            CTextField(
              label: LocaleKeys.address,
              maxLines: null,
              controller: _tECAddress,
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
