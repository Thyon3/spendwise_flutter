import '../entities/settings.dart';

abstract class SettingsRepository {
  Future<UserSettings> getSettings();
  Future<UserSettings> updateSettings(UserSettings settings);
}
