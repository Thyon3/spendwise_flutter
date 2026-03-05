import 'package:flutter/material.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscriptions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to add subscription
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSummaryCard(context),
          const SizedBox(height: 16),
          Text(
            'Active Subscriptions',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          _buildSubscriptionCard(
            context,
            name: 'Netflix',
            provider: 'Netflix Inc.',
            amount: 15.99,
            billingCycle: 'Monthly',
            nextBilling: DateTime.now().add(const Duration(days: 5)),
            color: Colors.red,
          ),
          const SizedBox(height: 8),
          _buildSubscriptionCard(
            context,
            name: 'Spotify Premium',
            provider: 'Spotify',
            amount: 9.99,
            billingCycle: 'Monthly',
            nextBilling: DateTime.now().add(const Duration(days: 12)),
            color: Colors.green,
          ),
          const SizedBox(height: 8),
          _buildSubscriptionCard(
            context,
            name: 'Adobe Creative Cloud',
            provider: 'Adobe',
            amount: 54.99,
            billingCycle: 'Monthly',
            nextBilling: DateTime.now().add(const Duration(days: 20)),
            color: Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Total',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '\$80.97',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Yearly: \$971.64',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionCard(
    BuildContext context, {
    required String name,
    required String provider,
    required double amount,
    required String billingCycle,
    required DateTime nextBilling,
    required Color color,
  }) {
    final daysUntil = nextBilling.difference(DateTime.now()).inDays;

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(Icons.subscriptions, color: color),
        ),
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(provider),
            const SizedBox(height: 4),
            Text(
              'Next billing in $daysUntil days',
              style: TextStyle(
                fontSize: 12,
                color: daysUntil <= 3 ? Colors.orange : Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              billingCycle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        onTap: () {
          // Navigate to subscription details
        },
      ),
    );
  }
}
