import 'package:flutter/material.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Insights'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInsightCard(
            context,
            icon: Icons.trending_up,
            iconColor: Colors.orange,
            title: 'Unusual Spending Detected',
            message: 'Your spending is 25% higher than usual this month',
            severity: 'WARNING',
          ),
          const SizedBox(height: 12),
          _buildInsightCard(
            context,
            icon: Icons.lightbulb_outline,
            iconColor: Colors.blue,
            title: 'Savings Opportunity',
            message: 'You could save \$50/month by reducing dining out expenses',
            severity: 'INFO',
          ),
          const SizedBox(height: 12),
          _buildInsightCard(
            context,
            icon: Icons.warning_amber,
            iconColor: Colors.red,
            title: 'Budget Alert',
            message: 'You\'ve used 90% of your Food budget for this month',
            severity: 'ALERT',
          ),
          const SizedBox(height: 12),
          _buildInsightCard(
            context,
            icon: Icons.celebration,
            iconColor: Colors.green,
            title: 'Great Job!',
            message: 'You\'re on track to save \$200 more than last month',
            severity: 'INFO',
          ),
          const SizedBox(height: 24),
          Text(
            'Spending Trends',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          _buildTrendCard(
            context,
            category: 'Dining Out',
            trend: 'INCREASING',
            percentage: 35,
            amount: 450,
          ),
          const SizedBox(height: 8),
          _buildTrendCard(
            context,
            category: 'Transportation',
            trend: 'DECREASING',
            percentage: -15,
            amount: 120,
          ),
          const SizedBox(height: 8),
          _buildTrendCard(
            context,
            category: 'Shopping',
            trend: 'STABLE',
            percentage: 2,
            amount: 280,
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String message,
    required String severity,
  }) {
    Color backgroundColor;
    switch (severity) {
      case 'ALERT':
        backgroundColor = Colors.red.withOpacity(0.1);
        break;
      case 'WARNING':
        backgroundColor = Colors.orange.withOpacity(0.1);
        break;
      default:
        backgroundColor = Colors.blue.withOpacity(0.1);
    }

    return Card(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendCard(
    BuildContext context, {
    required String category,
    required String trend,
    required double percentage,
    required double amount,
  }) {
    final isIncreasing = trend == 'INCREASING';
    final isDecreasing = trend == 'DECREASING';
    final color = isIncreasing
        ? Colors.red
        : isDecreasing
            ? Colors.green
            : Colors.grey;

    return Card(
      child: ListTile(
        title: Text(category),
        subtitle: Text('\$${amount.toStringAsFixed(0)} this month'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isIncreasing
                  ? Icons.trending_up
                  : isDecreasing
                      ? Icons.trending_down
                      : Icons.trending_flat,
              color: color,
            ),
            const SizedBox(width: 4),
            Text(
              '${percentage > 0 ? '+' : ''}${percentage.toStringAsFixed(0)}%',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
