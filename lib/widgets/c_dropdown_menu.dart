import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';

import 'flutter/flutter_dropdown_menu.dart' as d;

class CDropdownMenu extends StatelessWidget {
  const CDropdownMenu({
    super.key,
    this.width,
    this.controller,
    this.onChanged,
    required this.labels,
    required this.label,
    this.leadingIcon,
    this.setSearchIcon = true,
    this.enableFilter = true,
    this.requestFocusOnTap = true,
  });

  final double? width;
  final TextEditingController? controller;
  final ValueChanged<int?>? onChanged;
  final List<String> labels;
  final String label;
  final Widget? leadingIcon;
  final bool setSearchIcon;
  final bool enableFilter;
  final bool requestFocusOnTap;

  bool get _isNoLeading {
    return !setSearchIcon && leadingIcon == null;
  }

  String _label(String text) {
    if (_isNoLeading) {
      return "  $text";
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    List<d.DropdownMenuEntry<_Item>> entries = [];

    for (var i = 0; i < labels.length; i++) {
      final item = _Item(i, labels[i]);
      entries.add(d.DropdownMenuEntry(
        value: item,
        label: _label(item.label),
      ));
    }

    return d.DropdownMenu<_Item>(
      width: width,
      menuHeight: 0.4.toDynamicHeight(context),
      controller: controller,
      enableFilter: enableFilter,
      requestFocusOnTap: requestFocusOnTap,
      leadingIcon: _getIcon,
      label: Text(label),
      inputDecorationTheme: const InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(vertical: 5.0),
        border: OutlineInputBorder(),
      ),
      onSelected: onChanged != null
          ? (value) => onChanged!.call(value?.index ?? -1)
          : (value) {
              controller?.text = value?.label.trim() ?? "";
            },
      dropdownMenuEntries: entries,
    );
  }

  Widget? get _getIcon {
    if (leadingIcon != null) return leadingIcon!;
    if (setSearchIcon) return _searchIcon;
    return null;
  }

  Widget get _searchIcon {
    return const Icon(Icons.search_rounded);
  }
}

final class _Item {
  final int index;
  final String label;

  const _Item(this.index, this.label);
}
