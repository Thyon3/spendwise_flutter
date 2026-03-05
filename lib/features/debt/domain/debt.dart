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
  final DateTime createdAt;

  Debt({
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
    required this.createdAt,
  });

  factory Debt.fromJson(Map<String, dynamic> json) {
    return Debt(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      totalAmount: json['totalAmount'].toDouble(),
      remainingAmount: json['remainingAmount'].toDouble(),
      interestRate: json['interestRate']?.toDouble(),
      currency: json['currency'],
      startDate: DateTime.parse(json['startDate']),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      minimumPayment: json['minimumPayment']?.toDouble(),
      isPaidOff: json['isPaidOff'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  double get progressPercentage => 
      ((totalAmount - remainingAmount) / totalAmount * 100).clamp(0, 100);
}
