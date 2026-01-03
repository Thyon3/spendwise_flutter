import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../auth/application/auth_notifier.dart';
import '../../auth/application/auth_state.dart';
import '../../expenses/application/expense_list_notifier.dart';
import '../../expenses/application/expense_summary_notifier.dart';
import '../../categories/application/category_notifier.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState is Authenticated ? authState.user : null;
    final expenseListAsync = ref.watch(expenseListProvider);
    final summaryAsync = ref.watch(expenseSummaryProvider);
    final categoriesAsync = ref.watch(categoryListProvider);
    final filters = ref.watch(expenseFiltersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: () => context.push('/categories'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(expenseListProvider.notifier).loadExpenses();
          ref.read(expenseSummaryProvider.notifier).loadSummary();
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, ${user?.email.split('@')[0] ?? 'User'}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    summaryAsync.when(
                      data: (summary) => _SummaryCard(summary: summary),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Text('Error: $e'),
                    ),
                    const SizedBox(height: 24),
                    _FilterBar(
                      filters: filters,
                      categoriesAsync: categoriesAsync,
                    ),
                  ],
                ),
              ),
            ),
            expenseListAsync.when(
              data: (expenses) => SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final expense = expenses[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getColor(expense.category?.color),
                        child: const Icon(Icons.money, color: Colors.white),
                      ),
                      title: Text(expense.category?.name ?? 'No Category'),
                      subtitle: Text(DateFormat.yMMMd().format(expense.date)),
                      trailing: Text(
                        '${expense.currency} ${expense.amount.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () => context.push('/expenses/edit', extra: expense),
                    );
                  },
                  childCount: expenses.length,
                ),
              ),
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => SliverFillRemaining(
                child: Center(child: Text('Error loading expenses: $e')),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/expenses/add'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _getColor(String? hex) {
    if (hex == null) return Colors.grey;
    try {
      return Color(int.parse(hex.replaceAll('#', '0xff')));
    } catch (_) {
      return Colors.blue;
    }
  }
}

class _SummaryCard extends StatelessWidget {
  final dynamic summary;
  const _SummaryCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.deepPurple,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Total Expenses',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${summary.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterBar extends ConsumerWidget {
  final dynamic filters;
  final AsyncValue<dynamic> categoriesAsync;

  const _FilterBar({required this.filters, required this.categoriesAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.date_range),
          onPressed: () async {
            final range = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (range != null) {
              ref.read(expenseFiltersProvider.notifier).state =
                  filters.copyWith(from: range.start, to: range.end);
            }
          },
        ),
        const Spacer(),
        categoriesAsync.when(
          data: (categories) => DropdownButton<String>(
            value: filters.categoryId ?? 'all',
            items: [
              const DropdownMenuItem(value: 'all', child: Text('All Categories')),
              ...categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))),
            ],
            onChanged: (val) {
              ref.read(expenseFiltersProvider.notifier).state =
                  filters.copyWith(categoryId: val);
            },
          ),
          loading: () => const SizedBox(),
          error: (_, __) => const SizedBox(),
        ),
      ],
    );
  }
}
