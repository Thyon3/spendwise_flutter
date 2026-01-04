import '../../domain/entities/settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_remote_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource _remoteDataSource;

  SettingsRepositoryImpl(this._remoteDataSource);

  @override
  Future<UserSettings> getSettings() {
    return _remoteDataSource.getSettings();
  }

  @override
  Future<UserSettings> updateSettings(UserSettings settings) {
    return _remoteDataSource.updateSettings(settings);
  }
}
