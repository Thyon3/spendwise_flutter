class Income {
  final String id;
  final double amount;
  final String currency;
  final String? description;
  final DateTime date;
  final String categoryId;
  final String? categoryName;
  final String? categoryColor;

  Income({
    required this.id,
    required this.amount,
    required this.currency,
    this.description,
    required this.date,
    required this.categoryId,
    this.categoryName,
    this.categoryColor,
  });

  factory Income.fromJson(Map<String, dynamic> json) {
    return Income(
      id: json['id'],
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      categoryId: json['categoryId'],
      categoryName: json['category']?['name'],
      categoryColor: json['category']?['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currency': currency,
      'description': description,
      'date': date.toIso8601String(),
      'categoryId': categoryId,
    };
  }
}
