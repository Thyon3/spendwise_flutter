import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/income_provider.dart';
// import 'add_income_page.dart'; // Will resolve when created

class IncomeListPage extends ConsumerWidget {
  const IncomeListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incomeState = ref.watch(incomeListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Income'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
               context.push('/incomes/add');
            },
          )
        ],
      ),
      body: incomeState.when(
        data: (incomes) {
          if (incomes.isEmpty) {
            return const Center(child: Text('No income records found.'));
          }
          return ListView.builder(
            itemCount: incomes.length,
            itemBuilder: (context, index) {
              final income = incomes[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: _parseColor(income.categoryColor),
                  child: Text(income.categoryName?.substring(0, 1).toUpperCase() ?? '?'),
                ),
                title: Text(income.description ?? income.categoryName ?? 'Income'),
                subtitle: Text(income.date.toString().split(' ')[0]),
                trailing: Text('+${income.currency} ${income.amount}', style: const TextStyle(color: Colors.green)),
                onLongPress: () {
                  ref.read(incomeListProvider.notifier).deleteIncome(income.id);
                },
                onTap: () => context.push('/incomes/edit', extra: income),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Color _parseColor(String? colorCode) {
    if (colorCode == null) return Colors.grey;
    try {
      return Color(int.parse(colorCode.replaceAll('#', '0xFF')));
    } catch (e) {
      return Colors.grey;
    }
  }
}
