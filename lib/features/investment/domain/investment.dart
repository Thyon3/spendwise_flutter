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
  final DateTime createdAt;

  Investment({
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
    required this.createdAt,
  });

  factory Investment.fromJson(Map<String, dynamic> json) {
    return Investment(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      symbol: json['symbol'],
      quantity: json['quantity'].toDouble(),
      purchasePrice: json['purchasePrice'].toDouble(),
      currentPrice: json['currentPrice'].toDouble(),
      currency: json['currency'],
      purchaseDate: DateTime.parse(json['purchaseDate']),
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  double get totalValue => quantity * currentPrice;
  double get totalCost => quantity * purchasePrice;
  double get profitLoss => totalValue - totalCost;
  double get profitLossPercentage => 
      ((currentPrice - purchasePrice) / purchasePrice * 100);
}
