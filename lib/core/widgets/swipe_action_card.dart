import 'package:flutter/material.dart';

class SwipeActionCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onShare;
  final Color editColor;
  final Color deleteColor;
  final Color shareColor;

  const SwipeActionCard({
    super.key,
    required this.child,
    this.onEdit,
    this.onDelete,
    this.onShare,
    this.editColor = Colors.blue,
    this.deleteColor = Colors.red,
    this.shareColor = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart && onDelete != null) {
          final result = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Confirm Delete'),
              content: const Text('Are you sure you want to delete this item?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: FilledButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Delete'),
                ),
              ],
            ),
          );
          if (result == true) {
            onDelete!();
          }
          return false;
        }
        if (direction == DismissDirection.startToEnd && onEdit != null) {
          onEdit!();
          return false;
        }
        return false;
      },
      background: Container(
        color: editColor,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: deleteColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: child,
    );
  }
}
