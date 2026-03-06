import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  final String text;
  final Color? color;
  final double thickness;
  final double spacing;

  const DividerWithText({
    super.key,
    required this.text,
    this.color,
    this.thickness = 1,
    this.spacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    final dividerColor = color ?? Colors.grey[300];

    return Row(
      children: [
        Expanded(
          child: Divider(
            color: dividerColor,
            thickness: thickness,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ),
        Expanded(
          child: Divider(
            color: dividerColor,
            thickness: thickness,
          ),
        ),
      ],
    );
  }
}
