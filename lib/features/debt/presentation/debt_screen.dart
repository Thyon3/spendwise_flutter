import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/debt.dart';
import 'debt_provider.dart';

class DebtScreen extends ConsumerWidget {
  const DebtScreen({super.key});

  static const _types = ['LOAN', 'CREDIT_CARD', 'MORTGAGE', 'PERSONAL'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debtsAsync = ref.watch(debtsProvider);
    final summaryAsync = ref.watch(debtSummaryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Debt Tracker')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDebtSheet(context, ref),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          summaryAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (summary) => _SummaryBanner(summary: summary),
          ),
          Expanded(
            child: debtsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (debts) => debts.isEmpty
                  ? const Center(child: Text('No debts tracked.'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: debts.length,
                      itemBuilder: (_, i) => _DebtCard(
                        debt: debts[i],
                        onPayment: () => _showPaymentDialog(context, ref, debts[i]),
                        onDelete: () => ref.read(debtsProvider.notifier).delete(debts[i].id),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDebtSheet(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final totalCtrl = TextEditingController();
    final remainingCtrl = TextEditingController();
    String selectedType = _types.first;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 24, bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: StatefulBuilder(
          builder: (ctx, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Add Debt', style: Theme.of(ctx).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(labelText: 'Type', border: OutlineInputBorder()),
                items: _types.map((t) => DropdownMenuItem(value: t, child: Text(t.replaceAll('_', ' ')))).toList(),
                onChanged: (v) => setState(() => selectedType = v!),
              ),
              const SizedBox(height: 12),
              TextField(controller: totalCtrl, decoration: const InputDecoration(labelText: 'Total amount', border: OutlineInputBorder()), keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              TextField(controller: remainingCtrl, decoration: const InputDecoration(labelText: 'Remaining amount', border: OutlineInputBorder()), keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  final name = nameCtrl.text.trim();
                  final total = double.tryParse(totalCtrl.text);
                  final remaining = double.tryParse(remainingCtrl.text);
                  if (name.isEmpty || total == null || remaining == null) return;
                  ref.read(debtsProvider.notifier).create({
                    'name': name, 'type': selectedType,
                    'totalAmount': total, 'remainingAmount': remaining,
                    'currency': 'USD', 'startDate': DateTime.now().toIso8601String(),
                  });
                  Navigator.pop(ctx);
                },
                child: const Text('Add Debt'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPaymentDialog(BuildContext context, WidgetRef ref, Debt debt) {
    final amountCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Log Payment — ${debt.name}'),
        content: TextField(controller: amountCtrl, decoration: const InputDecoration(labelText: 'Payment amount'), keyboardType: TextInputType.number, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final amount = double.tryParse(amountCtrl.text);
              if (amount != null && amount > 0) {
                ref.read(debtsProvider.notifier).addPayment(debt.id, {
                  'amount': amount, 'principalAmount': amount,
                  'interestAmount': 0, 'paymentDate': DateTime.now().toIso8601String(),
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Log'),
          ),
        ],
      ),
    );
  }
}

class _SummaryBanner extends StatelessWidget {
  final Map<String, dynamic> summary;
  const _SummaryBanner({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Stat(label: 'Total Debt', value: '\$${(summary['totalDebt'] ?? 0).toStringAsFixed(0)}'),
          _Stat(label: 'Active', value: '${summary['active'] ?? 0}'),
          _Stat(label: 'Paid Off', value: '${summary['paidOff'] ?? 0}'),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      );
}

class _DebtCard extends StatelessWidget {
  final Debt debt;
  final VoidCallback onPayment;
  final VoidCallback onDelete;

  const _DebtCard({required this.debt, required this.onPayment, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(debt.name, style: theme.textTheme.titleMedium)),
                Chip(label: Text(debt.type.replaceAll('_', ' '))),
                IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: onDelete),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: debt.progress, color: debt.isPaidOff ? Colors.green : theme.colorScheme.primary),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Paid: ${debt.currency} ${debt.paidAmount.toStringAsFixed(2)}', style: theme.textTheme.bodySmall),
                Text('Remaining: ${debt.currency} ${debt.remainingAmount.toStringAsFixed(2)}', style: theme.textTheme.bodySmall),
              ],
            ),
            if (!debt.isPaidOff) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(onPressed: onPayment, icon: const Icon(Icons.payment), label: const Text('Log Payment')),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
