import 'package:flutter/material.dart';

class ExpenseFilterSheet extends StatefulWidget {
  const ExpenseFilterSheet({super.key});

  @override
  State<ExpenseFilterSheet> createState() => _ExpenseFilterSheetState();
}

class _ExpenseFilterSheetState extends State<ExpenseFilterSheet> {
  DateTimeRange? dateRange;
  String? selectedCategory;
  double? minAmount;
  double? maxAmount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Expenses',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Date Range'),
            subtitle: Text(dateRange != null
                ? '${dateRange!.start.toString().split(' ')[0]} - ${dateRange!.end.toString().split(' ')[0]}'
                : 'All time'),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                setState(() => dateRange = picked);
              }
            },
          ),
          ListTile(
            title: const Text('Category'),
            subtitle: Text(selectedCategory ?? 'All categories'),
            trailing: const Icon(Icons.category),
            onTap: () {
              // Show category picker
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Min Amount',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    minAmount = double.tryParse(value);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Max Amount',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    maxAmount = double.tryParse(value);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      dateRange = null;
                      selectedCategory = null;
                      minAmount = null;
                      maxAmount = null;
                    });
                  },
                  child: const Text('Clear'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'dateRange': dateRange,
                      'category': selectedCategory,
                      'minAmount': minAmount,
                      'maxAmount': maxAmount,
                    });
                  },
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
