class Investment {
  final String id;
  final String name;
  final String type;
  final String? symbol;
  final double quantity;
  final double purchasePrice;
  final double currentPrice;
  final String currency;
  final DateTime purchaseDate;
  final String? notes;

  const Investment({
    required this.id,
    required this.name,
    required this.type,
    this.symbol,
    required this.quantity,
    required this.purchasePrice,
    required this.currentPrice,
    required this.currency,
    required this.purchaseDate,
    this.notes,
  });

  double get totalValue => quantity * currentPrice;
  double get totalCost => quantity * purchasePrice;
  double get gainLoss => totalValue - totalCost;
  double get gainLossPercent => totalCost > 0 ? (gainLoss / totalCost) * 100 : 0;
  bool get isProfit => gainLoss >= 0;

  factory Investment.fromJson(Map<String, dynamic> json) => Investment(
        id: json['id'] as String,
        name: json['name'] as String,
        type: json['type'] as String,
        symbol: json['symbol'] as String?,
        quantity: (json['quantity'] as num).toDouble(),
        purchasePrice: (json['purchasePrice'] as num).toDouble(),
        currentPrice: (json['currentPrice'] as num).toDouble(),
        currency: json['currency'] as String,
        purchaseDate: DateTime.parse(json['purchaseDate'] as String),
        notes: json['notes'] as String?,
      );
}
