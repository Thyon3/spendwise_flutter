enum PeriodType {
  WEEKLY,
  MONTHLY,
  CUSTOM_RANGE,
}

class Budget {
  final String id;
  final String userId;
  final String name;
  final double amountLimit;
  final String currency;
  final PeriodType periodType;
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final String? categoryId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Budget({
    required this.id,
    required this.userId,
    required this.name,
    required this.amountLimit,
    required this.currency,
    required this.periodType,
    this.periodStart,
    this.periodEnd,
    this.categoryId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      amountLimit: (json['amountLimit'] as num).toDouble(),
      currency: json['currency'],
      periodType: PeriodType.values.firstWhere((e) => e.name == json['periodType']),
      periodStart: json['periodStart'] != null ? DateTime.parse(json['periodStart']) : null,
      periodEnd: json['periodEnd'] != null ? DateTime.parse(json['periodEnd']) : null,
      categoryId: json['categoryId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class BudgetStatus {
  final String budgetId;
  final String budgetName;
  final DateTime periodStart;
  final DateTime periodEnd;
  final double amountLimit;
  final double amountSpent;
  final double percentageUsed;
  final bool isOverLimit;
  final bool isNearLimit;

  BudgetStatus({
    required this.budgetId,
    required this.budgetName,
    required this.periodStart,
    required this.periodEnd,
    required this.amountLimit,
    required this.amountSpent,
    required this.percentageUsed,
    required this.isOverLimit,
    required this.isNearLimit,
  });

  factory BudgetStatus.fromJson(Map<String, dynamic> json) {
    return BudgetStatus(
      budgetId: json['budgetId'],
      budgetName: json['budgetName'],
      periodStart: DateTime.parse(json['periodStart']),
      periodEnd: DateTime.parse(json['periodEnd']),
      amountLimit: (json['amountLimit'] as num).toDouble(),
      amountSpent: (json['amountSpent'] as num).toDouble(),
      percentageUsed: (json['percentageUsed'] as num).toDouble(),
      isOverLimit: json['isOverLimit'],
      isNearLimit: json['isNearLimit'],
    );
  }
}
