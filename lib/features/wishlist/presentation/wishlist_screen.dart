import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/wishlist_item.dart';
import 'wishlist_provider.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistAsync = ref.watch(wishlistProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSheet(context, ref),
        child: const Icon(Icons.add),
      ),
      body: wishlistAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (items) {
          if (items.isEmpty) return const Center(child: Text('Your wishlist is empty.'));
          final pending = items.where((i) => !i.isPurchased).toList();
          final purchased = items.where((i) => i.isPurchased).toList();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (pending.isNotEmpty) ...[
                Text('Pending (${pending.length})', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...pending.map((i) => _WishlistTile(item: i, ref: ref)),
              ],
              if (purchased.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text('Purchased (${purchased.length})', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                const SizedBox(height: 8),
                ...purchased.map((i) => _WishlistTile(item: i, ref: ref)),
              ],
            ],
          );
        },
      ),
    );
  }

  void _showAddSheet(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final costCtrl = TextEditingController();
    final urlCtrl = TextEditingController();
    int priority = 3;

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
              Text('Add to Wishlist', style: Theme.of(ctx).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Item name', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: costCtrl, decoration: const InputDecoration(labelText: 'Estimated cost', border: OutlineInputBorder()), keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              TextField(controller: urlCtrl, decoration: const InputDecoration(labelText: 'URL (optional)', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              Row(children: [
                const Text('Priority: '),
                ...List.generate(5, (i) => IconButton(
                  icon: Icon(i < priority ? Icons.star : Icons.star_border, color: Colors.amber),
                  onPressed: () => setState(() => priority = i + 1),
                  padding: EdgeInsets.zero, constraints: const BoxConstraints(),
                )),
              ]),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  final name = nameCtrl.text.trim();
                  final cost = double.tryParse(costCtrl.text);
                  if (name.isEmpty || cost == null) return;
                  ref.read(wishlistProvider.notifier).create({
                    'name': name, 'estimatedCost': cost, 'currency': 'USD', 'priority': priority,
                    if (urlCtrl.text.isNotEmpty) 'url': urlCtrl.text.trim(),
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

class _WishlistTile extends StatelessWidget {
  final WishlistItem item;
  final WidgetRef ref;
  const _WishlistTile({required this.item, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: item.isPurchased ? Colors.green.shade100 : Colors.orange.shade100,
          child: Icon(item.isPurchased ? Icons.check : Icons.shopping_bag_outlined,
              color: item.isPurchased ? Colors.green : Colors.orange),
        ),
        title: Text(item.name, style: TextStyle(decoration: item.isPurchased ? TextDecoration.lineThrough : null)),
        subtitle: Row(children: [
          Text('${item.currency} ${item.estimatedCost.toStringAsFixed(2)}'),
          const SizedBox(width: 8),
          ...List.generate(item.priority, (_) => const Icon(Icons.star, size: 12, color: Colors.amber)),
        ]),
        trailing: item.isPurchased
            ? IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => ref.read(wishlistProvider.notifier).delete(item.id))
            : Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(icon: const Icon(Icons.check_circle_outline, color: Colors.green), onPressed: () => ref.read(wishlistProvider.notifier).markPurchased(item.id)),
                IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => ref.read(wishlistProvider.notifier).delete(item.id)),
              ]),
      ),
    );
  }
}
