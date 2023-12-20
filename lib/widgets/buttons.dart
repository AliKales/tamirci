import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';

final class Buttons {
  final BuildContext context;
  String text;
  VoidCallback onTap;
  final Icon? icon;
  final Color? background;

  Buttons(
    this.context,
    String t,
    this.onTap, {
    this.icon,
    this.background,
  }) : text = t.toUpperCase();

  bool get _isIcon => icon != null;

  Widget filled() {
    if (_isIcon) {
      return FilledButton.icon(
        onPressed: onTap,
        style: FilledButton.styleFrom(backgroundColor: background),
        icon: icon!,
        label: Text(
          text,
        ),
      );
    }
    return FilledButton(
      onPressed: onTap,
      child: Text(
        text,
      ),
    );
  }

  Widget outlined() {
    if (_isIcon) {
      return OutlinedButton.icon(
        onPressed: onTap,
        icon: icon!,
        label: Text(
          text,
        ),
      );
    }
    return OutlinedButton(
      onPressed: onTap,
      child: Text(
        text,
      ),
    );
  }

  Widget textB() {
    if (_isIcon) {
      return TextButton.icon(
        onPressed: onTap,
        icon: icon!,
        label: Text(text.toLowerCase().capitalize()),
      );
    }
    return TextButton(
      onPressed: onTap,
      child: Text(text.toLowerCase().capitalize()),
    );
  }
}
