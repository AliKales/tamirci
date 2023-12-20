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
  });

  final TextEditingController? controller;
  final String? label;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final String? initialValue;
  final int? maxLines;
  final int? length;
  final double? width;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final String? prefixText;

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
              child: _textField(),
            )
          : _textField(),
    );
  }

  TextField _textField() {
    return TextField(
      maxLength: length,
      maxLines: maxLines,
      readOnly: readOnly,
      onChanged: (value) => onChanged?.call(value.trim()),
      controller: _controller,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
          prefixText: prefixText,
          counterText: ""),
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
    );
  }
}

class CTextFormatter extends TextInputFormatter {
  final RegExp regExp;

  const CTextFormatter(this.regExp);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    RegExp regex = regExp;

    if (!regex.hasMatch(newText)) {
      return oldValue;
    }

    return newValue;
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
