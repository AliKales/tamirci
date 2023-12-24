import 'package:caroby/caroby.dart';
import 'package:flutter/services.dart';

extension ExtStringNull on String? {
  void copy() {
    if (isEmptyOrNull) return;
    Clipboard.setData(ClipboardData(text: this!));
  }

  int? get toIntOrNull {
    return int.tryParse(this ?? "");
  }

  double? get toDoubleOrNull {
    return double.tryParse(this ?? "");
  }

  String substringSafe(int start, [int? end]) {
    int l = this?.length ?? 0;
    if (isEmptyOrNull || l < start) {
      return "";
    }
    if (end != null && end > l) end = l;

    return this!.substring(start, end);
  }

  String get removeSpaces {
    return this?.replaceAll(" ", "") ?? "";
  }
}

extension ExtString on String {
  TextSelection get cursorPosition {
    return TextSelection.fromPosition(TextPosition(offset: length));
  }

  String get withSpaces {
    final list = split("");
    String t = "";

    for (var i = 0; i < list.length; i++) {
      //if it is the end
      if (i == list.count) {
        t += list[i];
      } else {
        String nextChar = list[i + 1];
        String currentChar = list[i];

        bool isNextNumeric = int.tryParse(nextChar) != null;
        bool isCurrentNumeric = int.tryParse(currentChar) != null;

        String newChar = "$currentChar ";

        if (isNextNumeric == isCurrentNumeric) {
          newChar = newChar.trim();
        }

        t += newChar;
      }
    }

    return t.trim();
  }
}
