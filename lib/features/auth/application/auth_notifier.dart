import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/repositories/auth_repository.dart';
import '../infrastructure/auth_infrastructure_providers.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    state = AuthLoading();
    try {
      final user = await _repository.login(email, password);
      state = Authenticated(user);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> register(String email, String password) async {
    state = AuthLoading();
    try {
      final user = await _repository.register(email, password);
      state = Authenticated(user);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> logout() async {
    state = AuthLoading();
    try {
      await _repository.logout();
      state = Unauthenticated();
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> loadCurrentUser() async {
    state = AuthLoading();
    try {
      final user = await _repository.getCurrentUser();
      state = Authenticated(user);
    } catch (e) {
      state = Unauthenticated();
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});
