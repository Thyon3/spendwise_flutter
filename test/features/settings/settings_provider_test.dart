import 'package:expense_tracker_frontend/features/settings/domain/entities/settings.dart';
import 'package:expense_tracker_frontend/features/settings/domain/repositories/settings_repository.dart';
import 'package:expense_tracker_frontend/features/settings/presentation/providers/settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class MockSettingsRepository implements SettingsRepository {
  UserSettings? settings;
  bool shouldThrow = false;

  @override
  Future<UserSettings> getSettings() async {
    if (shouldThrow) throw Exception('Error fetching settings');
    // Return default if null, similar to backend behavior? 
    // Or tests should set it.
    return settings ?? UserSettings(preferredCurrency: 'USD', theme: 'SYSTEM', notificationsEnabled: true);
  }

  @override
  Future<UserSettings> updateSettings(UserSettings s) async {
    if (shouldThrow) throw Exception('Error updating settings');
    settings = s;
    return s;
  }
}

void main() {
  late MockSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingsRepository();
  });

  test('loadSettings updates state', () async {
    final s = UserSettings(preferredCurrency: 'EUR', theme: 'DARK', notificationsEnabled: false);
    mockRepository.settings = s;

    final container = ProviderContainer(overrides: [
      settingsRepositoryProvider.overrideWithValue(mockRepository),
    ]);
    addTearDown(container.dispose);

    final notifier = container.read(settingsProvider.notifier);
    await notifier.getSettings();

    expect(container.read(settingsProvider), isA<AsyncData<UserSettings>>());
    expect(container.read(settingsProvider).value?.preferredCurrency, 'EUR');
    expect(container.read(settingsProvider).value?.theme, 'DARK');
  });

  test('updateCurrency updates state and repository', () async {
     final container = ProviderContainer(overrides: [
      settingsRepositoryProvider.overrideWithValue(mockRepository),
    ]);
    addTearDown(container.dispose);

    final notifier = container.read(settingsProvider.notifier);
    await notifier.getSettings(); // Load initial
    
    await notifier.updateCurrency('GBP');

    expect(container.read(settingsProvider).value?.preferredCurrency, 'GBP');
    expect(mockRepository.settings?.preferredCurrency, 'GBP');
  });

  test('updateTheme updates state and repository', () async {
     final container = ProviderContainer(overrides: [
      settingsRepositoryProvider.overrideWithValue(mockRepository),
    ]);
    addTearDown(container.dispose);

    final notifier = container.read(settingsProvider.notifier);
    await notifier.getSettings();
    
    await notifier.updateTheme('LIGHT');

    expect(container.read(settingsProvider).value?.theme, 'LIGHT');
    expect(mockRepository.settings?.theme, 'LIGHT');
  });
}
