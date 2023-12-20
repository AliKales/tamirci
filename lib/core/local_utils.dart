import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tamirci/core/extensions/ext_string.dart';

import '../locale_keys.dart';
import '../widgets/buttons.dart';

final class LocalUtils {
  const LocalUtils._();

  static Future<bool> askYesNo(
    BuildContext context,
    String title, [
    String? text,
  ]) async {
    return await CustomDialog.showCustomDialog<bool>(context,
            title: title,
            text: text,
            actions: [
              Buttons(context, LocaleKeys.no, () => context.pop(false)).textB(),
              Buttons(context, LocaleKeys.yes, () => context.pop(true)).textB(),
            ]) ??
        false;
  }

  static String formatTurkishPhone(String phone) {
    String p = phone;

    String f = p.substringSafe(0, 3);
    String s = p.substringSafe(3, 6);
    String r = p.substringSafe(6);

    return "($f) - $s - $r";
  }
}
