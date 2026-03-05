import 'package:flutter/material.dart';

class RecurringTransactionsScreen extends StatelessWidget {
  const RecurringTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Recurring Transactions'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Expenses'),
              Tab(text: 'Income'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // Navigate to add recurring transaction
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _buildExpensesList(),
            _buildIncomeList(),
          ],
        ),
      ),
    );
  }

  Widget _buildExpensesList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildRecurringCard(
          name: 'Rent',
          amount: 1500,
          frequency: 'Monthly',
          nextDate: DateTime.now().add(const Duration(days: 5)),
          category: 'Housing',
          color: Colors.blue,
        ),
        const SizedBox(height: 8),
        _buildRecurringCard(
          name: 'Internet',
          amount: 60,
          frequency: 'Monthly',
          nextDate: DateTime.now().add(const Duration(days: 15)),
          category: 'Utilities',
          color: Colors.orange,
        ),
        const SizedBox(height: 8),
        _buildRecurringCard(
          name: 'Gym Membership',
          amount: 45,
          frequency: 'Monthly',
          nextDate: DateTime.now().add(const Duration(days: 20)),
          category: 'Health',
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildIncomeList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildRecurringCard(
          name: 'Salary',
          amount: 5000,
          frequency: 'Monthly',
          nextDate: DateTime.now().add(const Duration(days: 10)),
          category: 'Employment',
          color: Colors.green,
          isIncome: true,
        ),
        const SizedBox(height: 8),
        _buildRecurringCard(
          name: 'Freelance Project',
          amount: 1200,
          frequency: 'Monthly',
          nextDate: DateTime.now().add(const Duration(days: 25)),
          category: 'Freelance',
          color: Colors.purple,
          isIncome: true,
        ),
      ],
    );
  }

  Widget _buildRecurringCard({
    required String name,
    required double amount,
    required String frequency,
    required DateTime nextDate,
    required String category,
    required Color color,
    bool isIncome = false,
  }) {
    final daysUntil = nextDate.difference(DateTime.now()).inDays;

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(
            isIncome ? Icons.arrow_downward : Icons.arrow_upward,
            color: color,
          ),
        ),
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$category • $frequency'),
            const SizedBox(height: 4),
            Text(
              'Next: in $daysUntil days',
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
              '${isIncome ? '+' : '-'}\$${amount.toStringAsFixed(0)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isIncome ? Colors.green : Colors.red,
              ),
            ),
            Switch(
              value: true,
              onChanged: (value) {
                // Toggle active status
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
        onTap: () {
          // Navigate to recurring transaction details
        },
      ),
    );
  }
}
