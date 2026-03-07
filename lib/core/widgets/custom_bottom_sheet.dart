import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {
  final String? title;
  final Widget child;
  final double? height;
  final bool showHandle;

  const CustomBottomSheet({
    super.key,
    this.title,
    required this.child,
    this.height,
    this.showHandle = true,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required Widget child,
    double? height,
    bool showHandle = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => CustomBottomSheet(
        title: title,
        height: height,
        showHandle: showHandle,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showHandle)
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          if (title != null) ...[
            Text(
              title!,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
          ],
          Flexible(child: child),
        ],
      ),
    );
  }
}
