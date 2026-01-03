class Tag {
  final String id;
  final String name;
  final String userId;

  Tag({
    required this.id,
    required this.name,
    required this.userId,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      name: json['name'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
