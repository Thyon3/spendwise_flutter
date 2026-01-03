import 'package:dio/dio.dart';
import '../errors/failures.dart';
import 'secure_storage_service.dart';

abstract class ApiClient {
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters});
  Future<Response> post(String path, {dynamic data});
}

class DioApiClient implements ApiClient {
  final Dio _dio;
  final SecureStorageService _storage;

  DioApiClient(String baseUrl, this._storage)
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          contentType: 'application/json',
        )) {
    _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  @override
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Failure _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return NetworkFailure();
    }
    
    if (e.response != null) {
      final message = e.response?.data?['error']?['message'] ?? 
                      e.response?.data?['message'] ?? 
                      'Something went wrong';
      return ServerFailure(message);
    }
    
    return ServerFailure('Unknown error occurred');
  }
}
