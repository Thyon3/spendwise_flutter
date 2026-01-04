import '../../../../core/network/api_client.dart';
import '../../domain/entities/settings.dart';

abstract class SettingsRemoteDataSource {
  Future<UserSettings> getSettings();
  Future<UserSettings> updateSettings(UserSettings settings);
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final ApiClient _apiClient;

  SettingsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<UserSettings> getSettings() async {
    final response = await _apiClient.get('/settings');
    return UserSettings.fromJson(response.data);
  }

  @override
  Future<UserSettings> updateSettings(UserSettings settings) async {
    final response = await _apiClient.put('/settings', data: settings.toJson());
    return UserSettings.fromJson(response.data);
  }
}
