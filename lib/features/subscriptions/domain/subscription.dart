class Subscription {
  final String id;
  final String name;
  final String provider;
  final double amount;
  final String currency;
  final String billingCycle;
  final DateTime nextBillingDate;
  final bool isActive;
  final int reminderDays;

  const Subscription({
    required this.id,
    required this.name,
    required this.provider,
    required this.amount,
    required this.currency,
    required this.billingCycle,
    required this.nextBillingDate,
    required this.isActive,
    required this.reminderDays,
  });

  bool get isUpcoming {
    final diff = nextBillingDate.difference(DateTime.now()).inDays;
    return diff >= 0 && diff <= reminderDays;
  }

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        id: json['id'] as String,
        name: json['name'] as String,
        provider: json['provider'] as String,
        amount: (json['amount'] as num).toDouble(),
        currency: json['currency'] as String,
        billingCycle: json['billingCycle'] as String,
        nextBillingDate: DateTime.parse(json['nextBillingDate'] as String),
        isActive: json['isActive'] as bool? ?? true,
        reminderDays: json['reminderDays'] as int? ?? 3,
      );
}
