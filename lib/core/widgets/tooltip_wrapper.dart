import 'package:flutter/material.dart';

class TooltipWrapper extends StatelessWidget {
  final Widget child;
  final String message;
  final TooltipTriggerMode triggerMode;
  final Duration waitDuration;
  final EdgeInsetsGeometry? padding;

  const TooltipWrapper({
    super.key,
    required this.child,
    required this.message,
    this.triggerMode = TooltipTriggerMode.longPress,
    this.waitDuration = const Duration(milliseconds: 500),
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      triggerMode: triggerMode,
      waitDuration: waitDuration,
      padding: padding ?? const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(4),
      ),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 12,
      ),
      child: child,
    );
  }
}
