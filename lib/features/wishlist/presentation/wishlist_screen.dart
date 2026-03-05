import 'package:flutter/material.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to add wishlist item
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildWishlistItem(
            context,
            name: 'New Laptop',
            description: 'MacBook Pro 14"',
            estimatedCost: 2499,
            priority: 5,
            targetDate: DateTime.now().add(const Duration(days: 90)),
          ),
          const SizedBox(height: 12),
          _buildWishlistItem(
            context,
            name: 'Vacation to Japan',
            description: 'Two weeks in Tokyo and Kyoto',
            estimatedCost: 5000,
            priority: 4,
            targetDate: DateTime.now().add(const Duration(days: 180)),
          ),
          const SizedBox(height: 12),
          _buildWishlistItem(
            context,
            name: 'New Phone',
            description: 'iPhone 15 Pro',
            estimatedCost: 1199,
            priority: 3,
            targetDate: DateTime.now().add(const Duration(days: 60)),
          ),
          const SizedBox(height: 12),
          _buildWishlistItem(
            context,
            name: 'Gaming Console',
            description: 'PlayStation 5',
            estimatedCost: 499,
            priority: 2,
            isPurchased: true,
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistItem(
    BuildContext context, {
    required String name,
    required String description,
    required double estimatedCost,
    required int priority,
    DateTime? targetDate,
    bool isPurchased = false,
  }) {
    final priorityColor = _getPriorityColor(priority);

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isPurchased
              ? Colors.green.withOpacity(0.2)
              : priorityColor.withOpacity(0.2),
          child: Icon(
            isPurchased ? Icons.check : Icons.card_giftcard,
            color: isPurchased ? Colors.green : priorityColor,
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            decoration: isPurchased ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            const SizedBox(height: 4),
            if (targetDate != null && !isPurchased)
              Text(
                'Target: ${_formatDate(targetDate)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            if (isPurchased)
              Text(
                'Purchased',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${estimatedCost.toStringAsFixed(0)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                decoration: isPurchased ? TextDecoration.lineThrough : null,
              ),
            ),
            if (!isPurchased)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < priority ? Icons.star : Icons.star_border,
                    size: 12,
                    color: priorityColor,
                  ),
                ),
              ),
          ],
        ),
        onTap: () {
          // Navigate to wishlist item details
        },
      ),
    );
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 5:
        return Colors.red;
      case 4:
        return Colors.orange;
      case 3:
        return Colors.yellow[700]!;
      case 2:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
