class FinancialSummary {
  final double income;
  final double expense;
  final double balance;

  FinancialSummary({
    required this.income,
    required this.expense,
    required this.balance,
  });

  factory FinancialSummary.fromJson(Map<String, dynamic> json) {
    return FinancialSummary(
      income: (json['income'] as num).toDouble(),
      expense: (json['expense'] as num).toDouble(),
      balance: (json['balance'] as num).toDouble(),
    );
  }
}
