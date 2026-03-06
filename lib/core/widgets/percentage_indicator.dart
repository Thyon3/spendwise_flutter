import 'package:flutter/material.dart';

class PercentageIndicator extends StatelessWidget {
  final double percentage;
  final double height;
  final Color? backgroundColor;
  final Color? progressColor;
  final bool showLabel;

  const PercentageIndicator({
    super.key,
    required this.percentage,
    this.height = 8,
    this.backgroundColor,
    this.progressColor,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final clampedPercentage = percentage.clamp(0.0, 100.0);
    final color = progressColor ?? _getColorForPercentage(clampedPercentage);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel)
          Text(
            '${clampedPercentage.toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        if (showLabel) const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: LinearProgressIndicator(
            value: clampedPercentage / 100,
            minHeight: height,
            backgroundColor: backgroundColor ?? Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Color _getColorForPercentage(double percentage) {
    if (percentage >= 90) return Colors.red;
    if (percentage >= 70) return Colors.orange;
    return Colors.green;
  }
}
