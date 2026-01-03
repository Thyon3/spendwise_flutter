import '../../../../core/network/secure_storage_service.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _storage;

  AuthRepositoryImpl(this._remoteDataSource, this._storage);

  @override
  Future<AuthUser> login(String email, String password) async {
    final result = await _remoteDataSource.login(email, password);
    final token = result['accessToken'];
    if (token != null) {
      await _storage.saveToken(token);
    }
    return AuthUser.fromJson(result['user']);
  }

  @override
  Future<AuthUser> register(String email, String password) async {
    final user = await _remoteDataSource.register(email, password);
    // Note: Register in our backend currently doesn't return token, 
    // we might need to login after register or update backend.
    // For now, let's assume we might need to login.
    return user;
  }

  @override
  Future<AuthUser> getCurrentUser() async {
    return _remoteDataSource.getCurrentUser();
  }

  @override
  Future<void> logout() async {
    await _storage.clearToken();
  }
}
