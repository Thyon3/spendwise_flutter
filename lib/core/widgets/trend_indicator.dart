import 'package:flutter/material.dart';

class TrendIndicator extends StatelessWidget {
  final double value;
  final bool showPercentage;
  final bool invertColors;

  const TrendIndicator({
    super.key,
    required this.value,
    this.showPercentage = true,
    this.invertColors = false,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = value >= 0;
    final displayColor = invertColors
        ? (isPositive ? Colors.red : Colors.green)
        : (isPositive ? Colors.green : Colors.red);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isPositive ? Icons.trending_up : Icons.trending_down,
          color: displayColor,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          showPercentage
              ? '${isPositive ? '+' : ''}${value.toStringAsFixed(1)}%'
              : '${isPositive ? '+' : ''}${value.toStringAsFixed(2)}',
          style: TextStyle(
            color: displayColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
