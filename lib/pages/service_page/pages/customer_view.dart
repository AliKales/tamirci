import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tamirci/core/extensions/ext_object.dart';
import 'package:tamirci/core/extensions/ext_string.dart';
import 'package:tamirci/core/extensions/ext_text_controller.dart';
import 'package:tamirci/core/local_values.dart';
import 'package:tamirci/core/models/m_customer.dart';
import 'package:tamirci/locale_keys.dart';
import 'package:tamirci/widgets/buttons.dart';
import 'package:tamirci/widgets/c_text_field.dart';

import '../../../widgets/phone_text_field.dart';

class CustomerViewController {
  MCustomer Function(MCustomer customer)? receiveCustomer;
  VoidCallback? updateTexts;

  void dispose() {
    receiveCustomer = null;
    updateTexts = null;
  }
}

class CustomerView extends StatefulWidget {
  const CustomerView({
    super.key,
    required this.customer,
    required this.controller,
    required this.isNew,
    required this.onFindCustomer,
  });

  final MCustomer customer;
  final CustomerViewController controller;
  final bool isNew;
  final ValueChanged<MapEntry<String, Object>> onFindCustomer;

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
    controller.updateTexts = _setTextControllers;

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

  void _findCustomer() {
    final phone = _tECPhone.textTrim;
    final idNo = _tECIdNo.textTrim;
    final taxNo = _tECTaxNo.textTrim;
    final name = _tECName.textTrim.singleSpace.toLowerCase();
    final surname = _tECLastName.textTrim.singleSpace.toLowerCase();
    final fullName = "$name$surname".toLowerCase().removeSpaces;

    if (phone.isNotEmptyAndNull) {
      widget.onFindCustomer
          .call(MapEntry("phone", phone.replaceAll("-", "").toInt));
    } else if (idNo.isNotEmptyAndNull) {
      widget.onFindCustomer.call(MapEntry("idNo", idNo.toInt));
    } else if (taxNo.isNotEmptyAndNull) {
      widget.onFindCustomer.call(MapEntry("taxNo", taxNo));
    } else if (name.isNotEmptyAndNull && surname.isEmptyOrNull) {
      widget.onFindCustomer.call(MapEntry("name", name));
    } else if (surname.isNotEmptyAndNull && name.isEmptyOrNull) {
      widget.onFindCustomer.call(MapEntry("surname", surname));
    } else if (fullName.isNotEmptyAndNull) {
      widget.onFindCustomer.call(MapEntry("fullName", fullName));
    }
  }

  MCustomer _receiveCustomer(MCustomer c) {
    final name = _tECName.textTrimOrNull?.singleSpace.toLowerCase();
    final surname = _tECLastName.textTrimOrNull?.singleSpace.toLowerCase();
    final fullName = ((name ?? "") + (surname ?? "").replaceAll(" ", ""));
    return c.copyWith(
      name: name,
      surname: surname,
      fullName: fullName,
      idNo: _tECIdNo.textTrim.toIntOrNull,
      taxNo: _tECTaxNo.textTrimOrNull,
      phone: _tECPhone.textTrimOrNull?.replaceAll("-", "").toIntOrNull,
      phoneCountryCode: _tECCountryCode.textTrim.toIntOrNull,
      address: _tECAddress.textTrimOrNull,
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
            PhoneTextField(
                tECCountryCode: _tECCountryCode, tECPhone: _tECPhone),
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
                LocalValues.digitsLetters,
              ],
              length: 10,
            ),
            CTextField(
              label: LocaleKeys.name,
              controller: _tECName,
            ),
            CTextField(
              label: LocaleKeys.lastName,
              controller: _tECLastName,
            ),
            if (widget.isNew)
              Buttons(
                context,
                LocaleKeys.findCustomer,
                _findCustomer,
              ).filled().centerAlign,
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
