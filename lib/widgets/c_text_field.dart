import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tamirci/core/extensions/ext_string.dart';

class CTextField extends StatelessWidget {
  const CTextField({
    super.key,
    this.controller,
    this.label,
    this.onChanged,
    this.readOnly = false,
    this.initialValue,
    this.maxLines = 1,
    this.width,
    this.inputFormatters,
    this.keyboardType,
    this.length,
    this.prefixText,
    this.textCapitalization = TextCapitalization.none,
    this.suffixIcon,
    this.prefixIcon,
    this.filled = false,
    this.isHighRadius = false,
    this.hintText,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final String? initialValue;
  final int? maxLines;
  final int? length;
  final double? width;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final String? prefixText;
  final TextCapitalization textCapitalization;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool filled;
  final bool isHighRadius;

  TextEditingController? get _controller {
    if (initialValue.isNotEmptyAndNull) {
      return TextEditingController(text: initialValue!);
    }
    return controller;
  }

  bool get _isSized {
    return width != null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: _isSized
          ? SizedBox(
              width: width,
              child: _textField(context),
            )
          : _textField(context),
    );
  }

  TextField _textField(BuildContext context) {
    return TextField(
      textCapitalization: textCapitalization,
      maxLength: length,
      maxLines: maxLines,
      readOnly: readOnly,
      onChanged: (value) => onChanged?.call(value.trim()),
      controller: _controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: filled ? BorderSide.none : const BorderSide(),
          borderRadius: isHighRadius
              ? BorderRadius.circular(60)
              : BorderRadius.circular(4),
        ),
        filled: filled,
        fillColor: context.colorScheme.primary.withOpacity(0.1),
        labelText: label,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        prefixText: prefixText,
        counterText: "",
        hintText: hintText,
      ),
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
    );
  }
}

class CMoneyFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    if (oldValue.text.length >= newValue.text.length) {
      return newValue;
    }

    final regex = RegExp(r'[0-9]');

    if (!regex.hasMatch(newText)) return oldValue;

    if (newText.split(".").length > 2) return oldValue;

    if (newText.contains(".") && newText.split(".").last.length > 2) {
      return oldValue;
    }

    return newValue.copyWith(text: newText);
  }
}

class CKilometerFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(".", "");
    final regex = RegExp(r'[0-9]*$');

    if (!regex.hasMatch(newText)) {
      return oldValue;
    }

    int l = newText.length;
    int howManyDots = l ~/ 3;

    List<String> numbers = [];

    if (l > 3) {
      for (var i = 0; i < howManyDots; i++) {
        int index = l - (i * 3);
        numbers.add(newText.substring(index - 3, index));
      }

      int remain = l % 3;

      newText = numbers.reversed.join(".");

      if (remain > 0) {
        newText = "${newValue.text.substring(0, remain)}.$newText";
      }
    }

    return newValue.copyWith(text: newText, selection: newText.cursorPosition);
  }
}

class CPhoneFormatter extends TextInputFormatter {
  final String? phoneCode;

  const CPhoneFormatter(this.phoneCode);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    if (_isTurkish) {
      if (newText.startsWith("0")) {
        newText = newText.replaceFirst("0", "");
      }

      if (newText.length > 3 && newText[3] != "-") {
        newText = "${newText.substring(0, 3)}-${newText.substring(3)}";
      }
      if (newText.length > 7 && newText[7] != "-") {
        newText = "${newText.substring(0, 7)}-${newText.substringSafe(7, 11)}";
      }
    }

    return newValue.copyWith(text: newText, selection: newText.cursorPosition);
  }

  bool get _isTurkish {
    if (phoneCode == "90") return true;
    return false;
  }
}
