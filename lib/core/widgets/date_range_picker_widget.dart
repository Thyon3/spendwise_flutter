import 'package:flutter/material.dart';

class DateRangePickerWidget extends StatelessWidget {
  final DateTimeRange? selectedRange;
  final Function(DateTimeRange?) onRangeSelected;
  final String label;

  const DateRangePickerWidget({
    super.key,
    required this.selectedRange,
    required this.onRangeSelected,
    this.label = 'Select Date Range',
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          initialDateRange: selectedRange,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context),
              child: child!,
            );
          },
        );

        if (picked != null) {
          onRangeSelected(picked);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: selectedRange != null
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => onRangeSelected(null),
                )
              : const Icon(Icons.calendar_today),
        ),
        child: Text(
          selectedRange != null
              ? '${_formatDate(selectedRange!.start)} - ${_formatDate(selectedRange!.end)}'
              : 'All time',
          style: TextStyle(
            color: selectedRange != null ? null : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
