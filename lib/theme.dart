import 'package:caroby/caroby.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final class CustomTheme {
  final bool isDark;
  final BuildContext context;

  CustomTheme(this.context, this.isDark);

  ThemeData theme() {
    final cS = _getColorScheme;

    if (!kIsWeb) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          systemNavigationBarColor: cS.background,
          systemNavigationBarDividerColor: cS.background,
          systemNavigationBarIconBrightness:
              isDark ? Brightness.light : Brightness.dark,
        ),
      );
    }

    final buttonTextStyle = context.textTheme.bodyMedium!.copyWith(
      fontWeight: FontWeight.bold,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: "Roboto",
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      colorScheme: cS,
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: buttonTextStyle,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          textStyle: buttonTextStyle,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          textStyle: buttonTextStyle,
        ),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        titleTextStyle: context.textTheme.headlineSmall!.copyWith(
          color: blackWhite(!isDark),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color blackWhite(bool isBlack) {
    if (isBlack) {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }

  ColorScheme get _getColorScheme {
    if (isDark) return const ColorScheme.dark();

    return const ColorScheme.light(
      primary: Color(0xFF14162B),
      onTertiary: Color(0xFF7DD071),
    );
  }
}
