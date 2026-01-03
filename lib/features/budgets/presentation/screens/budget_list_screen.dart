import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../domain/entities/budget.dart';
import '../application/budget_notifier.dart';
import '../../../categories/application/category_notifier.dart';

class BudgetListScreen extends ConsumerWidget {
  const BudgetListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusesAsync = ref.watch(budgetStatusListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(budgetStatusListProvider.notifier).loadStatuses(),
        child: statusesAsync.when(
          data: (statuses) => statuses.isEmpty
              ? const Center(child: Text('No budgets defined yet.'))
              : ListView.builder(
                  itemCount: statuses.length,
                  itemBuilder: (context, index) {
                    final status = statuses[index];
                    return _BudgetStatusCard(status: status);
                  },
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBudgetDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddBudgetDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    String periodType = 'MONTHLY';
    String? categoryId;

    final categoriesAsync = ref.read(categoryListProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Budget'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name (e.g. Groceries)')),
              TextField(controller: amountController, decoration: const InputDecoration(labelText: 'Limit Amount'), keyboardType: TextInputType.number),
              DropdownButtonFormField<String>(
                value: periodType,
                items: const [
                  DropdownMenuItem(value: 'WEEKLY', child: Text('Weekly')),
                  DropdownMenuItem(value: 'MONTHLY', child: Text('Monthly')),
                ],
                onChanged: (val) => periodType = val!,
                decoration: const InputDecoration(labelText: 'Period'),
              ),
              categoriesAsync.when(
                data: (categories) => DropdownButtonFormField<String>(
                  value: categoryId,
                  items: [
                    const DropdownMenuItem(value: null, child: Text('All Categories')),
                    ...categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))),
                  ],
                  onChanged: (val) => categoryId = val,
                  decoration: const InputDecoration(labelText: 'Category (Optional)'),
                ),
                loading: () => const CircularProgressIndicator(),
                error: (_, __) => const Text('Error loading categories'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && amountController.text.isNotEmpty) {
                final budget = Budget(
                  id: '',
                  userId: '',
                  name: nameController.text,
                  amountLimit: double.parse(amountController.text),
                  currency: 'USD',
                  periodType: PeriodType.values.firstWhere((e) => e.name == periodType),
                  categoryId: categoryId,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );
                ref.read(budgetListProvider.notifier).createBudget(budget).then((_) {
                  ref.read(budgetStatusListProvider.notifier).loadStatuses();
                  context.pop();
                });
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class _BudgetStatusCard extends StatelessWidget {
  final BudgetStatus status;
  const _BudgetStatusCard({required this.status});

  @override
  Widget build(BuildContext context) {
    Color progressColor = Colors.green;
    if (status.isOverLimit) {
      progressColor = Colors.red;
    } else if (status.isNearLimit) {
      progressColor = Colors.orange;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.between,
              children: [
                Text(status.budgetName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                  '\$${status.amountSpent.toStringAsFixed(2)} / \$${status.amountLimit.toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold, color: status.isOverLimit ? Colors.red : null),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: (status.percentageUsed / 100).clamp(0.0, 1.0),
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 10,
            ),
            const SizedBox(height: 8),
            Text(
              '${status.percentageUsed.toStringAsFixed(1)}% used',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
