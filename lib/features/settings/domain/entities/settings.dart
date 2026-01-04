class UserSettings {
  final String preferredCurrency;
  final String theme;
  final bool notificationsEnabled;

  UserSettings({
    required this.preferredCurrency,
    required this.theme,
    required this.notificationsEnabled,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      preferredCurrency: json['preferredCurrency'] ?? 'USD',
      theme: json['theme'] ?? 'SYSTEM',
      notificationsEnabled: json['notificationsEnabled'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'preferredCurrency': preferredCurrency,
      'theme': theme,
      'notificationsEnabled': notificationsEnabled,
    };
  }

  UserSettings copyWith({
    String? preferredCurrency,
    String? theme,
    bool? notificationsEnabled,
  }) {
    return UserSettings(
      preferredCurrency: preferredCurrency ?? this.preferredCurrency,
      theme: theme ?? this.theme,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}
