import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/user.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
}

class AuthState {
  final AuthStatus status;
  final User? user;

  AuthState({
    required this.status,
    this.user,
  });

  factory AuthState.initial() => AuthState(status: AuthStatus.initial);
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState.initial());

  void setAuthenticated(User user) {
    state = AuthState(status: AuthStatus.authenticated, user: user);
  }

  void setUnauthenticated() {
    state = AuthState(status: AuthStatus.unauthenticated);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
