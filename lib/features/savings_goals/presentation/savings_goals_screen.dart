import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/savings_goal.dart';
import 'savings_goals_provider.dart';

class SavingsGoalsScreen extends ConsumerWidget {
  const SavingsGoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(savingsGoalsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Savings Goals')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateSheet(context, ref),
        child: const Icon(Icons.add),
      ),
      body: goalsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (goals) => goals.isEmpty
            ? const Center(child: Text('No savings goals yet.'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: goals.length,
                itemBuilder: (_, i) => _GoalCard(
                  goal: goals[i],
                  onContribute: () => _showContributeDialog(context, ref, goals[i]),
                  onDelete: () => ref.read(savingsGoalsProvider.notifier).delete(goals[i].id),
                ),
              ),
      ),
    );
  }

  void _showCreateSheet(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final targetCtrl = TextEditingController();
    final currencyCtrl = TextEditingController(text: 'USD');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 24, bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('New Savings Goal', style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Goal name', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: targetCtrl, decoration: const InputDecoration(labelText: 'Target amount', border: OutlineInputBorder()), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            TextField(controller: currencyCtrl, decoration: const InputDecoration(labelText: 'Currency', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                final name = nameCtrl.text.trim();
                final target = double.tryParse(targetCtrl.text);
                if (name.isEmpty || target == null) return;
                ref.read(savingsGoalsProvider.notifier).create({
                  'name': name,
                  'targetAmount': target,
                  'currency': currencyCtrl.text.trim().toUpperCase(),
                });
                Navigator.pop(ctx);
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _showContributeDialog(BuildContext context, WidgetRef ref, SavingsGoal goal) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add to "${goal.name}"'),
        content: TextField(controller: ctrl, decoration: const InputDecoration(labelText: 'Amount'), keyboardType: TextInputType.number, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final amount = double.tryParse(ctrl.text);
              if (amount != null && amount > 0) {
                ref.read(savingsGoalsProvider.notifier).contribute(goal.id, amount);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final SavingsGoal goal;
  final VoidCallback onContribute;
  final VoidCallback onDelete;

  const _GoalCard({required this.goal, required this.onContribute, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = goal.isCompleted ? Colors.green : theme.colorScheme.primary;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(goal.name, style: theme.textTheme.titleMedium)),
                if (goal.isCompleted) const Icon(Icons.check_circle, color: Colors.green),
                IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: onDelete),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: goal.progress, color: color, backgroundColor: color.withOpacity(0.2)),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${goal.currency} ${goal.currentAmount.toStringAsFixed(2)}', style: theme.textTheme.bodySmall),
                Text('${goal.currency} ${goal.targetAmount.toStringAsFixed(2)}', style: theme.textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 8),
            if (!goal.isCompleted)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onContribute,
                  icon: const Icon(Icons.add),
                  label: const Text('Contribute'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
