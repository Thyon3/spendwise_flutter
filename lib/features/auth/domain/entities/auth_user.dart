class AuthUser {
  final String id;
  final String email;
  final DateTime createdAt;

  AuthUser({
    required this.id,
    required this.email,
    required this.createdAt,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'],
      email: json['email'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
