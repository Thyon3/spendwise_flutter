class WishlistItem {
  final String id;
  final String name;
  final String? description;
  final double estimatedCost;
  final String currency;
  final int priority;
  final DateTime? targetDate;
  final bool isPurchased;
  final String? url;

  const WishlistItem({
    required this.id,
    required this.name,
    this.description,
    required this.estimatedCost,
    required this.currency,
    required this.priority,
    this.targetDate,
    required this.isPurchased,
    this.url,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) => WishlistItem(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String?,
        estimatedCost: (json['estimatedCost'] as num).toDouble(),
        currency: json['currency'] as String,
        priority: json['priority'] as int? ?? 3,
        targetDate: json['targetDate'] != null ? DateTime.parse(json['targetDate']) : null,
        isPurchased: json['isPurchased'] as bool? ?? false,
        url: json['url'] as String?,
      );
}
