import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../application/budget_notifier.dart';
import '../../domain/entities/budget.dart';
import 'budget_form_screen.dart';

class BudgetsScreen extends ConsumerStatefulWidget {
  const BudgetsScreen({super.key});

  @override
  ConsumerState<BudgetsScreen> createState() => _BudgetsScreenState();
}

class _BudgetsScreenState extends ConsumerState<BudgetsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch fresh data when entering the screen
    Future.microtask(() {
      ref.read(budgetStatusListProvider.notifier).loadStatuses();
      ref.read(budgetListProvider.notifier).loadBudgets();
    });
  }

  void _navigateToForm([Budget? budget]) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BudgetFormScreen(budget: budget),
      ),
    );
    // Refresh after returning
    ref.read(budgetStatusListProvider.notifier).loadStatuses();
    ref.read(budgetListProvider.notifier).loadBudgets();
  }

  @override
  Widget build(BuildContext context) {
    final statusesAsync = ref.watch(budgetStatusListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        child: const Icon(Icons.add),
      ),
      body: statusesAsync.when(
        data: (statuses) => statuses.isEmpty
            ? const Center(child: Text('No budgets found. Create one!'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: statuses.length,
                itemBuilder: (context, index) {
                  final status = statuses[index];
                  return _BudgetCard(
                    status: status,
                    onTap: () async {
                      // Find the full budget object if needed, or pass ID to form to fetch
                      // For simplicity, we might need the full budget to edit.
                      // Let's grab it from the budgetListProvider which should be loaded too
                      final budgets = ref.read(budgetListProvider).valueOrNull;
                      final budget = budgets?.firstWhere((b) => b.id == status.budgetId);
                      if (budget != null) {
                        _navigateToForm(budget);
                      }
                    },
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _BudgetCard extends StatelessWidget {
  final BudgetStatus status;
  final VoidCallback onTap;

  const _BudgetCard({required this.status, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final progressColor = status.isOverLimit
        ? Colors.red
        : status.isNearLimit
            ? Colors.orange
            : Colors.green;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    status.budgetName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${status.percentageUsed.toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: progressColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: status.percentageUsed / 100,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Spent: \$${status.amountSpent.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Text(
                    'Limit: \$${status.amountLimit.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${DateFormat.MMMd().format(status.periodStart)} - ${DateFormat.MMMd().format(status.periodEnd)}',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
