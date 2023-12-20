import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';

final class LocalValues {
  const LocalValues._();

  static double radiusLargeXXX = 34;

  static EdgeInsetsGeometry paddingPage(BuildContext context) {
    final width = Values.paddingPageValue.toDynamicWidth(context);
    return EdgeInsets.symmetric(
      horizontal: width,
      vertical: 0.01.toDynamicHeight(context),
    );
  }
}
