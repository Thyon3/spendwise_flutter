class Subscription {
  final String id;
  final String name;
  final String provider;
  final double amount;
  final String currency;
  final String billingCycle;
  final DateTime startDate;
  final DateTime nextBillingDate;
  final DateTime? endDate;
  final bool isActive;
  final String? categoryId;
  final int reminderDays;
  final DateTime createdAt;

  Subscription({
    required this.id,
    required this.name,
    required this.provider,
    required this.amount,
    required this.currency,
    required this.billingCycle,
    required this.startDate,
    required this.nextBillingDate,
    this.endDate,
    required this.isActive,
    this.categoryId,
    required this.reminderDays,
    required this.createdAt,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      name: json['name'],
      provider: json['provider'],
      amount: json['amount'].toDouble(),
      currency: json['currency'],
      billingCycle: json['billingCycle'],
      startDate: DateTime.parse(json['startDate']),
      nextBillingDate: DateTime.parse(json['nextBillingDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isActive: json['isActive'],
      categoryId: json['categoryId'],
      reminderDays: json['reminderDays'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  double get yearlyAmount {
    switch (billingCycle) {
      case 'MONTHLY':
        return amount * 12;
      case 'YEARLY':
        return amount;
      case 'WEEKLY':
        return amount * 52;
      default:
        return amount * 12;
    }
  }

  int get daysUntilNextBilling {
    return nextBillingDate.difference(DateTime.now()).inDays;
  }
}
