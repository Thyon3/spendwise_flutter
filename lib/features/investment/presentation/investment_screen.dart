import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/investment.dart';
import 'investment_provider.dart';

class InvestmentScreen extends ConsumerWidget {
  const InvestmentScreen({super.key});

  static const _types = ['STOCKS', 'BONDS', 'MUTUAL_FUNDS', 'CRYPTO', 'REAL_ESTATE', 'OTHER'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invAsync = ref.watch(investmentsProvider);
    final portfolioAsync = ref.watch(portfolioSummaryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Investments')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSheet(context, ref),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          portfolioAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (p) => _PortfolioBanner(portfolio: p),
          ),
          Expanded(
            child: invAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (investments) => investments.isEmpty
                  ? const Center(child: Text('No investments yet.'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: investments.length,
                      itemBuilder: (_, i) => _InvestmentCard(
                        investment: investments[i],
                        onUpdatePrice: () => _showUpdatePriceDialog(context, ref, investments[i]),
                        onDelete: () => ref.read(investmentsProvider.notifier).delete(investments[i].id),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddSheet(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final symbolCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
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
              Text('Add Investment', style: Theme.of(ctx).textTheme.titleLarge),
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
              TextField(controller: symbolCtrl, decoration: const InputDecoration(labelText: 'Symbol (optional)', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: TextField(controller: qtyCtrl, decoration: const InputDecoration(labelText: 'Quantity', border: OutlineInputBorder()), keyboardType: TextInputType.number)),
                const SizedBox(width: 12),
                Expanded(child: TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'Purchase price', border: OutlineInputBorder()), keyboardType: TextInputType.number)),
              ]),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  final qty = double.tryParse(qtyCtrl.text);
                  final price = double.tryParse(priceCtrl.text);
                  if (nameCtrl.text.trim().isEmpty || qty == null || price == null) return;
                  ref.read(investmentsProvider.notifier).create({
                    'name': nameCtrl.text.trim(), 'type': selectedType,
                    if (symbolCtrl.text.isNotEmpty) 'symbol': symbolCtrl.text.trim().toUpperCase(),
                    'quantity': qty, 'purchasePrice': price, 'currentPrice': price,
                    'currency': 'USD', 'purchaseDate': DateTime.now().toIso8601String(),
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

  void _showUpdatePriceDialog(BuildContext context, WidgetRef ref, Investment inv) {
    final ctrl = TextEditingController(text: inv.currentPrice.toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Update price — ${inv.name}'),
        content: TextField(controller: ctrl, decoration: const InputDecoration(labelText: 'Current price'), keyboardType: TextInputType.number, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final price = double.tryParse(ctrl.text);
              if (price != null) { ref.read(investmentsProvider.notifier).updatePrice(inv.id, price); Navigator.pop(ctx); }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}

class _PortfolioBanner extends StatelessWidget {
  final Map<String, dynamic> portfolio;
  const _PortfolioBanner({required this.portfolio});

  @override
  Widget build(BuildContext context) {
    final gainLoss = (portfolio['gainLoss'] ?? 0.0) as num;
    final isProfit = gainLoss >= 0;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isProfit ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isProfit ? Colors.green.shade200 : Colors.red.shade200),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        _Stat(label: 'Total Value', value: '\$${(portfolio['totalValue'] ?? 0.0).toStringAsFixed(2)}'),
        _Stat(label: 'Gain/Loss', value: '${isProfit ? '+' : ''}\$${gainLoss.toStringAsFixed(2)}', color: isProfit ? Colors.green : Colors.red),
        _Stat(label: 'Holdings', value: '${portfolio['count'] ?? 0}'),
      ]),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  const _Stat({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) => Column(children: [
        Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: color)),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ]);
}

class _InvestmentCard extends StatelessWidget {
  final Investment investment;
  final VoidCallback onUpdatePrice;
  final VoidCallback onDelete;
  const _InvestmentCard({required this.investment, required this.onUpdatePrice, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isProfit = investment.isProfit;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isProfit ? Colors.green.shade100 : Colors.red.shade100,
          child: Text(investment.symbol ?? investment.name[0], style: TextStyle(color: isProfit ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
        ),
        title: Text(investment.name),
        subtitle: Text('${investment.quantity} units · ${investment.type.replaceAll('_', ' ')}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('\$${investment.totalValue.toStringAsFixed(2)}', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
            Text('${isProfit ? '+' : ''}${investment.gainLossPercent.toStringAsFixed(1)}%', style: TextStyle(color: isProfit ? Colors.green : Colors.red, fontSize: 12)),
          ],
        ),
        onTap: onUpdatePrice,
        onLongPress: onDelete,
      ),
    );
  }
}
