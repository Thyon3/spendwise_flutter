import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/income.dart';
import '../providers/income_provider.dart';
import '../../../categories/application/category_notifier.dart';

class IncomeAddEditPage extends ConsumerStatefulWidget {
  final Income? income;
  const IncomeAddEditPage({super.key, this.income});

  @override
  ConsumerState<IncomeAddEditPage> createState() => _IncomeAddEditPageState();
}

class _IncomeAddEditPageState extends ConsumerState<IncomeAddEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.income?.amount.toString() ?? '');
    _descriptionController = TextEditingController(text: widget.income?.description ?? '');
    _selectedDate = widget.income?.date ?? DateTime.now();
    _selectedCategoryId = widget.income?.categoryId;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We assume categories for Income are fetched via the same category provider
    // Ideally we might want to filter for 'INCOME' type categories,
    // but the backend `CategoryList` might return all or we need a specific provider.
    // For now, let's use the generic one and assume the backend handles type or we filter client side if needed.
    // Note: The previous backend work added `type` to Category. Frontend Category entity needs to be checked.
    final categoriesAsync = ref.watch(categoryListProvider);
    
    // We watch incomeListProvider state to see if loading (optional, improved UX)
    final incomeState = ref.watch(incomeListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.income == null ? 'Add Income' : 'Edit Income'),
        actions: widget.income != null
            ? [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _confirmDelete(context),
                )
              ]
            : null,
      ),
      body: categoriesAsync.when(
        data: (categories) {
           // Filter categories if 'type' is available on frontend entity.
           // Assuming 'type' isn't on frontend entity yet, we'll confirm later.
           // For now, show all.
          final incomeCategories = categories; 

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    prefixText: '\$ ',
                    border: const OutlineInputBorder(),
                    errorStyle: const TextStyle(color: Colors.red),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Please enter an amount';
                    if (double.tryParse(val) == null) return 'Invalid amount';
                    if (double.parse(val) <= 0) return 'Amount must be greater than 0';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedCategoryId,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: incomeCategories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                  onChanged: (val) => setState(() => _selectedCategoryId = val),
                  validator: (val) => val == null ? 'Please select a category' : null,
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text('${_selectedDate.toLocal()}'.split(' ')[0]),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  maxLength: 255,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: incomeState is AsyncLoading ? null : _submit,
                    child: incomeState is AsyncLoading
                        ? const CircularProgressIndicator()
                        : Text(widget.income == null ? 'Create' : 'Save Changes'),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text);
      final income = Income(
        id: widget.income?.id ?? '',
        amount: amount,
        currency: 'USD',
        date: _selectedDate,
        description: _descriptionController.text.trim(),
        categoryId: _selectedCategoryId!,
      );

      try {
        if (widget.income == null) {
          await ref.read(incomeListProvider.notifier).addIncome(income);
        } else {
          await ref.read(incomeListProvider.notifier).updateIncome(income);
        }
        if (mounted) context.pop();
      } catch (e) {
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Income'),
        content: const Text('Are you sure you want to delete this income?'),
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              context.pop();
              await ref.read(incomeListProvider.notifier).deleteIncome(widget.income!.id);
              if (mounted) context.pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
