import 'package:flutter/material.dart';

class BadgeWidget extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final double fontSize;

  const BadgeWidget({
    super.key,
    required this.text,
    this.color = Colors.red,
    this.textColor = Colors.white,
    this.fontSize = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class CountBadge extends StatelessWidget {
  final int count;
  final Color color;

  const CountBadge({
    super.key,
    required this.count,
    this.color = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    if (count == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      constraints: const BoxConstraints(
        minWidth: 18,
        minHeight: 18,
      ),
      child: Text(
        count > 99 ? '99+' : count.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
