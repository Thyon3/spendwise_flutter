class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, [this.code]);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException([String message = 'Network error occurred']) : super(message, 'NETWORK_ERROR');
}

class AuthException extends AppException {
  AuthException([String message = 'Authentication failed']) : super(message, 'AUTH_ERROR');
}

class ValidationException extends AppException {
  ValidationException([String message = 'Validation failed']) : super(message, 'VALIDATION_ERROR');
}

class NotFoundException extends AppException {
  NotFoundException([String message = 'Resource not found']) : super(message, 'NOT_FOUND');
}

class ServerException extends AppException {
  ServerException([String message = 'Server error occurred']) : super(message, 'SERVER_ERROR');
}

class CacheException extends AppException {
  CacheException([String message = 'Cache error occurred']) : super(message, 'CACHE_ERROR');
}
