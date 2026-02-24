import 'package:flutter/material.dart';

class QuickStatsWidget extends StatelessWidget {
  final double totalExpenses;
  final double totalIncome;
  final double netBalance;

  const QuickStatsWidget({
    super.key,
    required this.totalExpenses,
    required this.totalIncome,
    required this.netBalance,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStatRow(
              context,
              'Total Expenses',
              totalExpenses,
              Colors.red,
              Icons.arrow_downward,
            ),
            const Divider(),
            _buildStatRow(
              context,
              'Total Income',
              totalIncome,
              Colors.green,
              Icons.arrow_upward,
            ),
            const Divider(),
            _buildStatRow(
              context,
              'Net Balance',
              netBalance,
              netBalance >= 0 ? Colors.green : Colors.red,
              Icons.account_balance_wallet,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String label,
    double amount,
    Color color,
    IconData icon,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
