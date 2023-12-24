import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';

extension ExtTextField on TextEditingController {
  String? get textTrimOrNull {
    String t = text.trim();

    if (t.isEmptyOrNull) {
      return null;
    }
    return t;
  }
}
