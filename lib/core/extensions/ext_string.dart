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
}

extension ExtString on String {
  TextSelection get cursorPosition {
    return TextSelection.fromPosition(TextPosition(offset: length));
  }
}

