import 'package:flutter/material.dart';

class BottomSheetHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onClose;
  final List<Widget>? actions;

  const BottomSheetHeader({
    super.key,
    required this.title,
    this.onClose,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          if (actions != null) ...actions!,
          if (onClose != null)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: onClose ?? () => Navigator.pop(context),
            ),
        ],
      ),
    );
  }
}
