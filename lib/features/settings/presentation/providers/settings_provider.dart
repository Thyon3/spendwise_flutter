import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/network_providers.dart';
import '../../data/datasources/settings_remote_data_source.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/entities/settings.dart';

final settingsRemoteDataSourceProvider = Provider<SettingsRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SettingsRemoteDataSourceImpl(apiClient);
});

final settingsRepositoryProvider = Provider<SettingsRepositoryImpl>((ref) {
  final remote = ref.watch(settingsRemoteDataSourceProvider);
  return SettingsRepositoryImpl(remote);
});

final settingsProvider = StateNotifierProvider<SettingsNotifier, AsyncValue<UserSettings>>((ref) {
  return SettingsNotifier(ref.watch(settingsRepositoryProvider));
});

class SettingsNotifier extends StateNotifier<AsyncValue<UserSettings>> {
  final SettingsRepositoryImpl _repository;

  SettingsNotifier(this._repository) : super(const AsyncValue.loading()) {
    getSettings();
  }

  Future<void> getSettings() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getSettings());
  }

  Future<void> updateCurrency(String currency) async {
    final current = state.value;
    if (current == null) return;
    updateSettings(current.copyWith(preferredCurrency: currency));
  }
  
  Future<void> updateTheme(String theme) async {
    final current = state.value;
    if (current == null) return;
    updateSettings(current.copyWith(theme: theme));
  }

  Future<void> toggleNotifications(bool enabled) async {
    final current = state.value;
    if (current == null) return;
    updateSettings(current.copyWith(notificationsEnabled: enabled));
  }

  Future<void> updateSettings(UserSettings settings) async {
    state = await AsyncValue.guard(() => _repository.updateSettings(settings));
  }
}
