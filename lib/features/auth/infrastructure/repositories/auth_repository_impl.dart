import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<AuthUser> login(String email, String password) async {
    final result = await _remoteDataSource.login(email, password);
    // Token persistence will be added in F4
    return AuthUser.fromJson(result['user']);
  }

  @override
  Future<AuthUser> register(String email, String password) async {
    return _remoteDataSource.register(email, password);
  }

  @override
  Future<AuthUser> getCurrentUser() async {
    return _remoteDataSource.getCurrentUser();
  }

  @override
  Future<void> logout() async {
    // Clear tokens in F4
  }
}
