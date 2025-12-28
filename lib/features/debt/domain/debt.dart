class Debt {
  final String id;
  final String name;
  final String type;
  final double totalAmount;
  final double remainingAmount;
  final double? interestRate;
  final String currency;
  final DateTime startDate;
  final DateTime? dueDate;
  final double? minimumPayment;
  final bool isPaidOff;

  const Debt({
    required this.id,
    required this.name,
    required this.type,
    required this.totalAmount,
    required this.remainingAmount,
    this.interestRate,
    required this.currency,
    required this.startDate,
    this.dueDate,
    this.minimumPayment,
    required this.isPaidOff,
  });

  double get paidAmount => totalAmount - remainingAmount;
  double get progress => totalAmount > 0 ? (paidAmount / totalAmount).clamp(0.0, 1.0) : 0;

  factory Debt.fromJson(Map<String, dynamic> json) => Debt(
        id: json['id'] as String,
        name: json['name'] as String,
        type: json['type'] as String,
        totalAmount: (json['totalAmount'] as num).toDouble(),
        remainingAmount: (json['remainingAmount'] as num).toDouble(),
        interestRate: json['interestRate'] != null ? (json['interestRate'] as num).toDouble() : null,
        currency: json['currency'] as String,
        startDate: DateTime.parse(json['startDate'] as String),
        dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
        minimumPayment: json['minimumPayment'] != null ? (json['minimumPayment'] as num).toDouble() : null,
        isPaidOff: json['isPaidOff'] as bool? ?? false,
      );
}
