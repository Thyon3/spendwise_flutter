import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_client.dart';
import 'secure_storage_service.dart';
import '../config/app_config.dart';

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return DioApiClient(AppConfig.apiBaseUrl, storage);
});
