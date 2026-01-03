import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/expense.dart';
import '../../application/expense_ops_notifier.dart';
import '../../../categories/application/category_notifier.dart';

class ExpenseAddEditScreen extends ConsumerStatefulWidget {
  final Expense? expense;
  const ExpenseAddEditScreen({super.key, this.expense});

  @override
  ConsumerState<ExpenseAddEditScreen> createState() => _ExpenseAddEditScreenState();
}

class _ExpenseAddEditScreenState extends ConsumerState<ExpenseAddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.expense?.amount.toString() ?? '');
    _descriptionController = TextEditingController(text: widget.expense?.description ?? '');
    _selectedDate = widget.expense?.date ?? DateTime.now();
    _selectedCategoryId = widget.expense?.categoryId;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryListProvider);
    final opsState = ref.watch(expenseOpsProvider);

    ref.listen(expenseOpsProvider, (prev, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString()), backgroundColor: Colors.red),
        );
      } else if (next is AsyncData && prev is AsyncLoading) {
        context.pop();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.expense == null ? 'Add Expense' : 'Edit Expense'),
        actions: widget.expense != null
            ? [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    ref.read(expenseOpsProvider.notifier).deleteExpense(widget.expense!.id);
                  },
                )
              ]
            : null,
      ),
      body: categoriesAsync.when(
        data: (categories) => Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount', prefixText: '\$ '),
                keyboardType: TextInputType.number,
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategoryId,
                decoration: const InputDecoration(labelText: 'Category'),
                items: categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                onChanged: (val) => setState(() => _selectedCategoryId = val),
                validator: (val) => val == null ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Date'),
                subtitle: Text(_selectedDate.toString().split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (date != null) setState(() => _selectedDate = date);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description (Optional)'),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: opsState is AsyncLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          final expense = Expense(
                            id: widget.expense?.id ?? '',
                            amount: double.parse(_amountController.text),
                            currency: 'USD',
                            date: _selectedDate,
                            description: _descriptionController.text,
                            categoryId: _selectedCategoryId!,
                          );
                          if (widget.expense == null) {
                            ref.read(expenseOpsProvider.notifier).createExpense(expense);
                          } else {
                            ref.read(expenseOpsProvider.notifier).updateExpense(widget.expense!.id, expense);
                          }
                        }
                      },
                child: opsState is AsyncLoading
                    ? const CircularProgressIndicator()
                    : Text(widget.expense == null ? 'Create' : 'Save'),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
