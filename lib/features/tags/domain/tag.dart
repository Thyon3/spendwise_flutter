class Tag {
  final String id;
  final String name;
  final String userId;
  final DateTime createdAt;

  const Tag({
    required this.id,
    required this.name,
    required this.userId,
    required this.createdAt,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        id: json['id'] as String,
        name: json['name'] as String,
        userId: json['userId'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'userId': userId,
        'createdAt': createdAt.toIso8601String(),
      };
}
