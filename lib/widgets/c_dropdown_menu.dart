import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';

class CDropdownMenu extends StatelessWidget {
  const CDropdownMenu({
    super.key,
    this.width,
    this.controller,
    this.onChanged,
    required this.labels,
    required this.label,
  });

  final double? width;
  final TextEditingController? controller;
  final ValueChanged<int?>? onChanged;
  final List<String> labels;
  final String label;

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuEntry<_Item>> entries = [];

    for (var i = 0; i < labels.length; i++) {
      final item = _Item(i, labels[i]);
      entries.add(DropdownMenuEntry(value: item, label: item.label));
    }

    return DropdownMenu<_Item>(
      width: width,
      menuHeight: 0.4.toDynamicHeight(context),
      controller: controller,
      enableFilter: true,
      requestFocusOnTap: true,
      leadingIcon: const Icon(Icons.search),
      label: Text(label),
      inputDecorationTheme: const InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(vertical: 5.0),
        border: OutlineInputBorder(),
      ),
      onSelected: onChanged != null
          ? (value) => onChanged!.call(value?.index ?? -1)
          : (value) {
              controller?.text = value?.label ?? "";
            },
      dropdownMenuEntries: entries,
    );
  }
}

final class _Item {
  final int index;
  final String label;

  const _Item(this.index, this.label);
}
