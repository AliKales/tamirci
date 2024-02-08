import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:tamirci/widgets/buttons.dart';
import 'package:tamirci/widgets/c_text_field.dart';

import '../core/url_launcher.dart';
import '../locale_keys.dart';

class PhoneTextField extends StatelessWidget {
  const PhoneTextField({
    super.key,
    required this.tECCountryCode,
    required this.tECPhone,
    this.isNew = true,
  });

  final TextEditingController tECCountryCode;
  final TextEditingController tECPhone;
  final bool isNew;

  Future<void> _call(BuildContext context) async {
    bool result = await CustomDialog.showCustomDialog(context,
            text: LocaleKeys.sureToCall,
            actions: [
              Buttons(context, LocaleKeys.no, () => context.pop(false)).textB(),
              Buttons(context, LocaleKeys.yes, () => context.pop(true)).textB(),
            ]) ??
        false;
    if (!result) return;

    UrlLauncher.makeCall("+${tECCountryCode.text}${tECPhone.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 0.2.toDynamicWidth(context),
          child: CTextField(
            label: LocaleKeys.countryCode,
            controller: tECCountryCode,
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
          controller: tECPhone,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            CPhoneFormatter(tECCountryCode.textTrim),
          ],
          keyboardType: TextInputType.number,
        ).expanded,
        if (!isNew)
          IconButton.filled(
              onPressed: () => _call(context), icon: const Icon(Icons.call)),
      ],
    );
  }
}
