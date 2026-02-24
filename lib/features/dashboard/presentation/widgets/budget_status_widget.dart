import 'package:flutter/material.dart';

class BudgetStatusWidget extends StatelessWidget {
  final List<BudgetStatus> budgets;

  const BudgetStatusWidget({super.key, required this.budgets});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Budget Status',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...budgets.map((budget) => _buildBudgetItem(context, budget)),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetItem(BuildContext context, BudgetStatus budget) {
    final percentage = (budget.spent / budget.limit) * 100;
    final color = percentage > 90
        ? Colors.red
        : percentage > 70
            ? Colors.orange
            : Colors.green;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(budget.name),
              Text(
                '\$${budget.spent.toStringAsFixed(0)} / \$${budget.limit.toStringAsFixed(0)}',
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }
}

class BudgetStatus {
  final String name;
  final double spent;
  final double limit;

  BudgetStatus({
    required this.name,
    required this.spent,
    required this.limit,
  });
}
