import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tamirci/core/models/m_shop.dart';
import 'package:tamirci/widgets/c_text_field.dart';

final class LocalValues {
  const LocalValues._();

  static double radiusLargeXXX = 34;

  static MShop? shop;

  static EdgeInsetsGeometry paddingPage(BuildContext context) {
    final width = Values.paddingPageValue.toDynamicWidth(context);
    return EdgeInsets.symmetric(
      horizontal: width,
      vertical: 0.01.toDynamicHeight(context),
    );
  }

  static FilteringTextInputFormatter get digitsLetters {
    return FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'));
  }

  static List<TextInputFormatter>? get moneyFormatters {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]')),
      CMoneyFormatter(),
    ];
  }
}
