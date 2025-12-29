import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/payment_method.dart';
import 'payment_methods_provider.dart';

class PaymentMethodsScreen extends ConsumerWidget {
  const PaymentMethodsScreen({super.key});

  static const _types = ['CASH', 'CREDIT_CARD', 'DEBIT_CARD', 'BANK_TRANSFER', 'DIGITAL_WALLET'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pmAsync = ref.watch(paymentMethodsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Payment Methods')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSheet(context, ref),
        child: const Icon(Icons.add),
      ),
      body: pmAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (methods) => methods.isEmpty
            ? const Center(child: Text('No payment methods added yet.'))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: methods.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) => _PaymentMethodTile(
                  method: methods[i],
                  onSetDefault: () => ref.read(paymentMethodsProvider.notifier).setDefault(methods[i].id),
                  onDelete: () => ref.read(paymentMethodsProvider.notifier).delete(methods[i].id),
                ),
              ),
      ),
    );
  }

  void _showAddSheet(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final lastFourCtrl = TextEditingController();
    String selectedType = _types.first;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 16, right: 16, top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: StatefulBuilder(
          builder: (ctx, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Add Payment Method', style: Theme.of(ctx).textTheme.titleLarge),
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
              TextField(controller: lastFourCtrl, decoration: const InputDecoration(labelText: 'Last 4 digits (optional)', border: OutlineInputBorder()), maxLength: 4, keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  if (nameCtrl.text.trim().isEmpty) return;
                  ref.read(paymentMethodsProvider.notifier).create({
                    'name': nameCtrl.text.trim(),
                    'type': selectedType,
                    if (lastFourCtrl.text.isNotEmpty) 'lastFourDigits': lastFourCtrl.text,
                  });
                  Navigator.pop(ctx);
                },
                child: const Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final PaymentMethod method;
  final VoidCallback onSetDefault;
  final VoidCallback onDelete;

  const _PaymentMethodTile({required this.method, required this.onSetDefault, required this.onDelete});

  IconData get _icon {
    switch (method.type) {
      case 'CREDIT_CARD': return Icons.credit_card;
      case 'DEBIT_CARD': return Icons.credit_card_outlined;
      case 'BANK_TRANSFER': return Icons.account_balance;
      case 'DIGITAL_WALLET': return Icons.account_balance_wallet;
      default: return Icons.money;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Icon(_icon)),
      title: Text(method.name),
      subtitle: Text(method.type.replaceAll('_', ' ') + (method.lastFourDigits != null ? ' •••• ${method.lastFourDigits}' : '')),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (method.isDefault) const Chip(label: Text('Default'), padding: EdgeInsets.zero),
          if (!method.isDefault)
            IconButton(icon: const Icon(Icons.star_border), tooltip: 'Set default', onPressed: onSetDefault),
          IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: onDelete),
        ],
      ),
    );
  }
}
