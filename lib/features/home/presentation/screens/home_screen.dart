import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../auth/application/auth_notifier.dart';
import '../../auth/application/auth_state.dart';
import '../../expenses/application/expense_list_notifier.dart';
import '../../expenses/application/expense_summary_notifier.dart';
import '../../categories/application/category_notifier.dart';
import '../../expenses/application/tag_notifier.dart';
import '../../exports/infrastructure/export_service.dart';
import '../../../core/presentation/widgets/list_skeleton.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState is Authenticated ? authState.user : null;
    final expenseListAsync = ref.watch(expenseListProvider);
    final summaryAsync = ref.watch(expenseSummaryProvider);
    final categoriesAsync = ref.watch(categoryListProvider);
    final tagsAsync = ref.watch(tagListProvider);
    final filters = ref.watch(expenseFiltersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (val) => context.push(val),
            itemBuilder: (context) => [
              const PopupMenuItem(value: '/categories', child: Text('Categories')),
              const PopupMenuItem(value: '/tags', child: Text('Tags')),
              const PopupMenuItem(value: '/recurring-expenses', child: Text('Recurring Expenses')),
              const PopupMenuItem(value: '/reports', child: Text('Reports')),
              const PopupMenuItem(value: '/budgets', child: Text('Budgets')),
            ],
            icon: const Icon(Icons.menu),
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            tooltip: 'Export CSV',
            onPressed: () async {
              final currentFilters = ref.read(expenseFiltersProvider);
              try {
                await ref.read(exportServiceProvider).exportAndShareExpenses(
                      from: currentFilters.from,
                      to: currentFilters.to,
                      categoryId: currentFilters.categoryId,
                      tagId: currentFilters.tagId,
                      search: currentFilters.search,
                    );
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Export failed: $e')),
                  );
                }
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _confirmLogout(context, ref),
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
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    summaryAsync.when(
                      data: (summary) => _SummaryCard(summary: summary),
                      loading: () => _SummarySkeleton(),
                      error: (e, _) => Center(child: Text('Error: $e')),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search expenses...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  ref.read(expenseFiltersProvider.notifier).state = filters.copyWith(search: '');
                                },
                              )
                            : null,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onChanged: (val) {
                        // In a real app, use debouncing
                        ref.read(expenseFiltersProvider.notifier).state = filters.copyWith(search: val);
                      },
                    ),
                    const SizedBox(height: 16),
                    _FilterBar(
                      filters: filters,
                      categoriesAsync: categoriesAsync,
                      tagsAsync: tagsAsync,
                    ),
                  ],
                ),
              ),
            ),
            expenseListAsync.when(
              data: (expenses) => expenses.isEmpty
                  ? const SliverFillRemaining(child: Center(child: Text('No matching expenses.')))
                  : SliverList(
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
              loading: () => const SliverToBoxAdapter(child: ListSkeleton(itemCount: 8)),
              error: (e, _) => SliverFillRemaining(child: Center(child: Text('Error: $e'))),
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

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              context.pop();
              ref.read(authProvider.notifier).logout();
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final dynamic summary;
  const _SummaryCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.deepPurple,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text('Total Spent This Period', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Text(
              '\$${summary.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummarySkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(16)),
    );
  }
}

class _FilterBar extends ConsumerWidget {
  final dynamic filters;
  final AsyncValue<dynamic> categoriesAsync;
  final AsyncValue<dynamic> tagsAsync;

  const _FilterBar({required this.filters, required this.categoriesAsync, required this.tagsAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextButton.icon(
                onPressed: () async {
                  final range = await showDateRangePicker(
                    context: context,
                    initialDateRange: DateTimeRange(start: filters.from, end: filters.to),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (range != null) {
                    ref.read(expenseFiltersProvider.notifier).state = filters.copyWith(from: range.start, to: range.end);
                  }
                },
                icon: const Icon(Icons.date_range, size: 16),
                label: Text(
                  '${DateFormat.yMMMd().format(filters.from)} - ${DateFormat.yMMMd().format(filters.to)}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
            IconButton(
              icon: Icon(filters.sortOrder == 'asc' ? Icons.arrow_upward : Icons.arrow_downward, size: 16),
              onPressed: () {
                ref.read(expenseFiltersProvider.notifier).state =
                    filters.copyWith(sortOrder: filters.sortOrder == 'asc' ? 'desc' : 'asc');
              },
            ),
            PopupMenuButton<String>(
              initialValue: filters.sortBy,
              onSelected: (val) => ref.read(expenseFiltersProvider.notifier).state = filters.copyWith(sortBy: val),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'date', child: Text('Sort by Date')),
                const PopupMenuItem(value: 'amount', child: Text('Sort by Amount')),
              ],
              icon: const Icon(Icons.sort, size: 16),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: categoriesAsync.when(
                data: (categories) => DropdownButton<String>(
                  isExpanded: true,
                  value: filters.categoryId ?? 'all',
                  underline: const SizedBox(),
                  items: [
                    const DropdownMenuItem(value: 'all', child: Text('All Categories', style: TextStyle(fontSize: 12))),
                    ...categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name, style: const TextStyle(fontSize: 12)))),
                  ],
                  onChanged: (val) => ref.read(expenseFiltersProvider.notifier).state = filters.copyWith(categoryId: val),
                ),
                loading: () => const SizedBox(),
                error: (_, __) => const SizedBox(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: tagsAsync.when(
                data: (tags) => DropdownButton<String>(
                  isExpanded: true,
                  value: filters.tagId ?? 'all',
                  underline: const SizedBox(),
                  items: [
                    const DropdownMenuItem(value: 'all', child: Text('All Tags', style: TextStyle(fontSize: 12))),
                    ...tags.map((t) => DropdownMenuItem(value: t.id, child: Text(t.name, style: const TextStyle(fontSize: 12)))),
                  ],
                  onChanged: (val) => ref.read(expenseFiltersProvider.notifier).state = filters.copyWith(tagId: val),
                ),
                loading: () => const SizedBox(),
                error: (_, __) => const SizedBox(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
