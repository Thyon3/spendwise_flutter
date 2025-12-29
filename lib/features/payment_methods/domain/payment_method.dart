class PaymentMethod {
  final String id;
  final String name;
  final String type;
  final String? lastFourDigits;
  final bool isDefault;
  final bool isActive;

  const PaymentMethod({
    required this.id,
    required this.name,
    required this.type,
    this.lastFourDigits,
    required this.isDefault,
    required this.isActive,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        id: json['id'] as String,
        name: json['name'] as String,
        type: json['type'] as String,
        lastFourDigits: json['lastFourDigits'] as String?,
        isDefault: json['isDefault'] as bool? ?? false,
        isActive: json['isActive'] as bool? ?? true,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'lastFourDigits': lastFourDigits,
        'isDefault': isDefault,
      };
}
