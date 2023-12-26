import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tamirci/widgets/c_text_field.dart';

import '../locale_keys.dart';

class PhoneTextField extends StatelessWidget {
  const PhoneTextField({
    super.key,
    required TextEditingController tECCountryCode,
    required TextEditingController tECPhone,
  })  : _tECCountryCode = tECCountryCode,
        _tECPhone = tECPhone;

  final TextEditingController _tECCountryCode;
  final TextEditingController _tECPhone;

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
