export enum RecurrenceType {
  none,
  daily,
  weekly,
  monthly,
  yearly,
}

extension RecurrenceTypeExtension on RecurrenceType {
  String toShortString() => toString().split('.').last.toUpperCase();
  
  static RecurrenceType fromString(String val) {
    return RecurrenceType.values.firstWhere(
      (e) => e.toShortString() == val.toUpperCase(),
      orElse: () => RecurrenceType.none,
    );
  }

  String get label {
    switch (this) {
      case RecurrenceType.none: return 'None';
      case RecurrenceType.daily: return 'Daily';
      case RecurrenceType.weekly: return 'Weekly';
      case RecurrenceType.monthly: return 'Monthly';
      case RecurrenceType.yearly: return 'Yearly';
    }
  }
}

class RecurringExpenseRule {
  final String id;
  final double amount;
  final String currency;
  final String? description;
  final String categoryId;
  final RecurrenceType recurrenceType;
  final int interval;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;

  RecurringExpenseRule({
    required this.id,
    required this.amount,
    required this.currency,
    this.description,
    required this.categoryId,
    required this.recurrenceType,
    required this.interval,
    required this.startDate,
    this.endDate,
    required this.isActive,
  });

  factory RecurringExpenseRule.fromJson(Map<String, dynamic> json) {
    return RecurringExpenseRule(
      id: json['id'],
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'],
      description: json['description'],
      categoryId: json['categoryId'],
      recurrenceType: RecurrenceTypeExtension.fromString(json['recurrenceType']),
      interval: json['interval'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currency': currency,
      'description': description,
      'categoryId': categoryId,
      'recurrenceType': recurrenceType.toShortString(),
      'interval': interval,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isActive': isActive,
    };
  }
}
