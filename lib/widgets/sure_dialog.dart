import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tamirci/locale_keys.dart';
import 'package:tamirci/widgets/buttons.dart';

final class SureDialog {
  const SureDialog._();

  static Future<bool> areYouSure(BuildContext context) async {
    return await CustomDialog.showCustomDialog<bool>(context,
            title: LocaleKeys.areYouSure,
            actions: [
              Buttons(context, LocaleKeys.no, () => context.pop(false)).textB(),
              Buttons(context, LocaleKeys.yes, () => context.pop(true)).textB(),
            ]) ??
        false;
  }
}
