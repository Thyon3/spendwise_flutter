import '../../../core/network/api_client.dart';
import '../entities/auth_user.dart';

class AuthRemoteDataSource {
  final ApiClient _client;

  AuthRemoteDataSource(this._client);

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _client.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    return response.data;
  }

  Future<AuthUser> register(String email, String password) async {
    final response = await _client.post('/auth/register', data: {
      'email': email,
      'password': password,
    });
    return AuthUser.fromJson(response.data);
  }

  Future<AuthUser> getCurrentUser() async {
    final response = await _client.get('/auth/me');
    return AuthUser.fromJson(response.data);
  }
}
