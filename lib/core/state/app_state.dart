import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppState {
  final bool isLoading;
  final String? error;
  final bool isOnline;
  final String selectedCurrency;
  final bool notificationsEnabled;
  final DateTime? lastSyncTime;

  const AppState({
    this.isLoading = false,
    this.error,
    this.isOnline = true,
    this.selectedCurrency = 'USD',
    this.notificationsEnabled = true,
    this.lastSyncTime,
  });

  AppState copyWith({
    bool? isLoading,
    String? error,
    bool? isOnline,
    String? selectedCurrency,
    bool? notificationsEnabled,
    DateTime? lastSyncTime,
  }) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isOnline: isOnline ?? this.isOnline,
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          error == other.error &&
          isOnline == other.isOnline &&
          selectedCurrency == other.selectedCurrency &&
          notificationsEnabled == other.notificationsEnabled &&
          lastSyncTime == other.lastSyncTime;

  @override
  int get hashCode =>
      isLoading.hashCode ^
      error.hashCode ^
      isOnline.hashCode ^
      selectedCurrency.hashCode ^
      notificationsEnabled.hashCode ^
      lastSyncTime.hashCode;
}

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(const AppState());

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void setError(String? error) {
    state = state.copyWith(error: error, isLoading: false);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void setOnlineStatus(bool isOnline) {
    state = state.copyWith(isOnline: isOnline);
  }

  void setSelectedCurrency(String currency) {
    state = state.copyWith(selectedCurrency: currency);
  }

  void setNotificationsEnabled(bool enabled) {
    state = state.copyWith(notificationsEnabled: enabled);
  }

  void updateLastSyncTime() {
    state = state.copyWith(lastSyncTime: DateTime.now());
  }

  void reset() {
    state = const AppState();
  }
}

final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>(
  (ref) => AppStateNotifier(),
);

final isLoadingProvider = Selector<AppState, bool>(
  (appState) => appState.isLoading,
);

final errorProvider = Selector<AppState, String?>(
  (appState) => appState.error,
);

final isOnlineProvider = Selector<AppState, bool>(
  (appState) => appState.isOnline,
);

final selectedCurrencyProvider = Selector<AppState, String>(
  (appState) => appState.selectedCurrency,
);

final notificationsEnabledProvider = Selector<AppState, bool>(
  (appState) => appState.notificationsEnabled,
);

final lastSyncTimeProvider = Selector<AppState, DateTime?>(
  (appState) => appState.lastSyncTime,
);
