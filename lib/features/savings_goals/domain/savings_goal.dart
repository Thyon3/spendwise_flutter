class SavingsGoal {
  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final String currency;
  final DateTime? deadline;
  final String? description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  SavingsGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.currency,
    this.deadline,
    this.description,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  double get progress => targetAmount > 0 ? (currentAmount / targetAmount) * 100 : 0;
  double get remainingAmount => targetAmount - currentAmount;

  factory SavingsGoal.fromJson(Map<String, dynamic> json) {
    return SavingsGoal(
      id: json['id'],
      name: json['name'],
      targetAmount: json['targetAmount'].toDouble(),
      currentAmount: json['currentAmount'].toDouble(),
      currency: json['currency'],
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      description: json['description'],
      isCompleted: json['isCompleted'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'currency': currency,
      'deadline': deadline?.toIso8601String(),
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
