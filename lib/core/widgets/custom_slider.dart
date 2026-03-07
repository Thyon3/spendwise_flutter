import 'package:flutter/material.dart';

class CustomSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final String? label;
  final int? divisions;
  final Color? activeColor;

  const CustomSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.label,
    this.divisions,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
        ],
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
          activeColor: activeColor,
          label: value.toStringAsFixed(divisions != null ? 0 : 1),
        ),
      ],
    );
  }
}
