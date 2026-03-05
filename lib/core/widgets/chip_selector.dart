import 'package:flutter/material.dart';

class ChipSelector<T> extends StatelessWidget {
  final List<ChipItem<T>> items;
  final T? selectedValue;
  final Function(T) onSelected;
  final bool multiSelect;

  const ChipSelector({
    super.key,
    required this.items,
    this.selectedValue,
    required this.onSelected,
    this.multiSelect = false,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        final isSelected = selectedValue == item.value;
        return FilterChip(
          label: Text(item.label),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              onSelected(item.value);
            }
          },
          avatar: item.icon != null
              ? Icon(item.icon, size: 18)
              : null,
        );
      }).toList(),
    );
  }
}

class ChipItem<T> {
  final String label;
  final T value;
  final IconData? icon;

  ChipItem({
    required this.label,
    required this.value,
    this.icon,
  });
}
