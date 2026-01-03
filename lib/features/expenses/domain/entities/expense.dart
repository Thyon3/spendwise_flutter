import '../../categories/domain/entities/category.dart';

class Expense {
  final String id;
  final double amount;
  final String currency;
  final String? description;
  final DateTime date;
  final String categoryId;
  final Category? category;

  Expense({
    required this.id,
    required this.amount,
    required this.currency,
    this.description,
    required this.date,
    required this.categoryId,
    this.category,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      categoryId: json['categoryId'],
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
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

class ExpenseSummary {
  final double totalAmount;
  final List<CategoryTotal> byCategory;

  ExpenseSummary({
    required this.totalAmount,
    required this.byCategory,
  });

  factory ExpenseSummary.fromJson(Map<String, dynamic> json) {
    return ExpenseSummary(
      totalAmount: (json['totalAmount'] as num).toDouble(),
      byCategory: (json['byCategory'] as List)
          .map((item) => CategoryTotal.fromJson(item))
          .toList(),
    );
  }
}

class CategoryTotal {
  final String categoryId;
  final double total;

  CategoryTotal({
    required this.categoryId,
    required this.total,
  });

  factory CategoryTotal.fromJson(Map<String, dynamic> json) {
    return CategoryTotal(
      categoryId: json['categoryId'],
      total: (json['total'] as num).toDouble(),
    );
  }
}
