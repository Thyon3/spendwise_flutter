import 'package:flutter/material.dart';

class CustomTabIndicator extends Decoration {
  final Color color;
  final double height;
  final double radius;

  const CustomTabIndicator({
    this.color = Colors.blue,
    this.height = 3,
    this.radius = 0,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomTabIndicatorPainter(
      color: color,
      height: height,
      radius: radius,
      onChanged: onChanged,
    );
  }
}

class _CustomTabIndicatorPainter extends BoxPainter {
  final Color color;
  final double height;
  final double radius;

  _CustomTabIndicatorPainter({
    required this.color,
    required this.height,
    required this.radius,
    VoidCallback? onChanged,
  }) : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final size = configuration.size!;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final rect = Rect.fromLTWH(
      offset.dx,
      offset.dy + size.height - height,
      size.width,
      height,
    );

    if (radius > 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(radius)),
        paint,
      );
    } else {
      canvas.drawRect(rect, paint);
    }
  }
}
