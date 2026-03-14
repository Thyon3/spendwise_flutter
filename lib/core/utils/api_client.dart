import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  final Duration timeout;
  final Map<String, String> defaultHeaders;
  final bool enableLogging;

  ApiClient({
    required this.baseUrl,
    this.timeout = const Duration(seconds: 30),
    this.defaultHeaders = const {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    this.enableLogging = false,
  });

  // GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _request<T>(
      'GET',
      endpoint,
      headers: headers,
      queryParameters: queryParameters,
    );
  }

  // POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _request<T>(
      'POST',
      endpoint,
      headers: headers,
      body: body,
      queryParameters: queryParameters,
    );
  }

  // PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _request<T>(
      'PUT',
      endpoint,
      headers: headers,
      body: body,
      queryParameters: queryParameters,
    );
  }

  // PATCH request
  Future<ApiResponse<T>> patch<T>(
    String endpoint, {
    Map<String, String>? headers,
      dynamic body,
      Map<String, dynamic>? queryParameters,
    }) async {
    return _request<T>(
      'PATCH',
      endpoint,
      headers: headers,
      body: body,
      queryParameters: queryParameters,
    );
  }

  // DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _request<T>(
      'DELETE',
      endpoint,
      headers: headers,
      queryParameters: queryParameters,
    );
  }

  // Upload file
  Future<ApiResponse<T>> uploadFile<T>(
    String endpoint,
    File file, {
    Map<String, String>? headers,
    Map<String, String>? fields,
    String? fileKey = 'file',
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      final request = http.MultipartRequest('POST', uri);

      // Add headers
      request.headers.addAll(defaultHeaders);
      if (headers != null) {
        request.headers.addAll(headers);
      }

      // Add form fields
      if (fields != null) {
        fields.forEach((key, value) {
          request.fields[key] = value;
        });
      }

      // Add file
      final fileBytes = await file.readAsBytes();
      final multipartFile = http.MultipartFile.fromBytes(
        fileKey,
        fileBytes,
        filename: file.path.split('/').last,
      );
      request.files.add(multipartFile);

      if (enableLogging) {
        print('UPLOAD: ${request.method} ${request.url}');
        print('File: ${file.path}');
      }

      final response = await request.send().timeout(timeout);
      return _handleResponse<T>(response);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  // Download file
  Future<ApiResponse<Uint8List>> downloadFile(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      final requestHeaders = {...defaultHeaders};
      if (headers != null) {
        requestHeaders.addAll(headers);
      }

      if (enableLogging) {
        print('DOWNLOAD: GET $uri');
      }

      final response = await http.get(uri, headers: requestHeaders).timeout(timeout);
      return _handleResponse<Uint8List>(response);
    } catch (e) {
      return _handleError<Uint8List>(e);
    }
  }

  // Private request method
  Future<ApiResponse<T>> _request<T>(
    String method,
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      final requestHeaders = {...defaultHeaders};
      if (headers != null) {
        requestHeaders.addAll(headers);
      }

      // Log request
      if (enableLogging) {
        print('$method $uri');
        if (body != null) {
          print('Body: ${_encodeBody(body)}');
        }
      }

      late http.Response response;

      switch (method) {
        case 'GET':
          response = await http.get(uri, headers: requestHeaders).timeout(timeout);
          break;
        case 'POST':
          response = await http.post(
            uri,
            headers: requestHeaders,
            body: body != null ? _encodeBody(body) : null,
          ).timeout(timeout);
          break;
        case 'PUT':
          response = await http.put(
            uri,
            headers: requestHeaders,
            body: body != null ? _encodeBody(body) : null,
          ).timeout(timeout);
          break;
        case 'PATCH':
          response = await http.patch(
            uri,
            headers: requestHeaders,
            body: body != null ? _encodeBody(body) : null,
          ).timeout(timeout);
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: requestHeaders).timeout(timeout);
          break;
        default:
          throw UnsupportedError('Unsupported HTTP method: $method');
      }

      // Log response
      if (enableLogging) {
        print('Response: ${response.statusCode} ${response.body}');
      }

      return _handleResponse<T>(response);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  // Build URI with query parameters
  Uri _buildUri(String endpoint, Map<String, dynamic>? queryParameters) {
    final url = '$baseUrl$endpoint';
    
    if (queryParameters == null || queryParameters.isEmpty) {
      return Uri.parse(url);
    }

    final queryString = queryParameters.entries
        .where((entry) => entry.value != null)
        .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value.toString())}')
        .join('&');

    return Uri.parse('$url?$queryString');
  }

  // Encode body for HTTP request
  String? _encodeBody(dynamic body) {
    if (body == null) return null;
    
    if (body is String) {
      return body;
    }
    
    return jsonEncode(body);
  }

  // Handle successful response
  ApiResponse<T> _handleResponse<T>(http.Response response) {
    final statusCode = response.statusCode;
    final headers = response.headers;
    final body = response.body;

    ApiResponse<T> apiResponse = ApiResponse<T>(
      statusCode: statusCode,
      headers: headers,
      data: null,
      message: response.reasonPhrase,
    );

    if (statusCode >= 200 && statusCode < 300) {
      try {
        if (body.isNotEmpty) {
          if (body is Uint8List) {
            apiResponse.data = body as T;
          } else {
            final decodedBody = utf8.decode(body);
            apiResponse.data = jsonDecode(decodedBody) as T;
          }
        }
      } catch (e) {
        // If JSON parsing fails, return raw body as string
        if (body is String) {
          apiResponse.data = body as T;
        } else {
          apiResponse.data = utf8.decode(body) as T;
        }
      }
    } else {
      apiResponse.message = _parseErrorMessage(body);
    }

    return apiResponse;
  }

  // Handle error
  ApiResponse<T> _handleError<T>(dynamic error) {
    String message = 'Unknown error occurred';
    int statusCode = 500;

    if (error is SocketException) {
      message = 'Network error: Unable to connect to server';
      statusCode = 0;
    } else if (error is HttpException) {
      message = error.message;
      statusCode = 500;
    } else if (error is TimeoutException) {
      message = 'Request timeout';
      statusCode = 408;
    } else if (error is FormatException) {
      message = 'Invalid response format';
      statusCode = 500;
    } else {
      message = error.toString();
    }

    return ApiResponse<T>(
      statusCode: statusCode,
      headers: {},
      data: null,
      message: message,
    );
  }

  // Parse error message from response body
  String _parseErrorMessage(dynamic body) {
    if (body == null || body.isEmpty) {
      return 'Request failed';
    }

    try {
      if (body is String) {
        final decoded = jsonDecode(body);
        if (decoded is Map && decoded.containsKey('message')) {
          return decoded['message'];
        } else if (decoded is Map && decoded.containsKey('error')) {
          return decoded['error'];
        }
      } else if (body is Map) {
        if (body.containsKey('message')) {
          return body['message'];
        } else if (body.containsKey('error')) {
          return body['error'];
        }
      }
    } catch (e) {
      // If parsing fails, return raw body
    }

    return body.toString();
  }

  // Set authentication token
  void setAuthToken(String token) {
    defaultHeaders['Authorization'] = 'Bearer $token';
  }

  // Remove authentication token
  void removeAuthToken() {
    defaultHeaders.remove('Authorization');
  }

  // Set default header
  void setDefaultHeader(String key, String value) {
    defaultHeaders[key] = value;
  }

  // Remove default header
  void removeDefaultHeader(String key) {
    defaultHeaders.remove(key);
  }

  // Enable/disable logging
  void setLogging(bool enabled) {
    enableLogging = enabled;
  }

  // Check if response is successful
  bool isSuccess(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  // Check if response is client error
  bool isClientError(int statusCode) {
    return statusCode >= 400 && statusCode < 500;
  }

  // Check if response is server error
  bool isServerError(int statusCode) {
    return statusCode >= 500 && statusCode < 600;
  }
}

class ApiResponse<T> {
  final int statusCode;
  final Map<String, String> headers;
  final T? data;
  final String message;

  ApiResponse({
    required this.statusCode,
    required this.headers,
    this.data,
    required this.message,
  });

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
  bool get isClientError => statusCode >= 400 && statusCode < 500;
  bool get isServerError => statusCode >= 500 && statusCode < 600;

  @override
  String toString() {
    return 'ApiResponse(statusCode: $statusCode, message: $message, data: $data)';
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  final dynamic data;

  ApiException(this.statusCode, this.message, [this.data]);

  @override
  String toString() {
    return 'ApiException(statusCode: $statusCode, message: $message)';
  }
}

class NetworkException extends ApiException {
  NetworkException(String message) : super(0, message);
}

class TimeoutException extends ApiException {
  TimeoutException(String message) : super(408, message);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(String message, [dynamic data]) : super(401, message, data);
}

class ForbiddenException extends ApiException {
  ForbiddenException(String message, [dynamic data]) : super(403, message, data);
}

class NotFoundException extends ApiException {
  NotFoundException(String message, [dynamic data]) : super(404, message, data);
}

class BadRequestException extends ApiException {
  BadRequestException(String message, [dynamic data]) : super(400, message, data);
}

class ServerException extends ApiException {
  ServerException(String message, [dynamic data]) : super(500, message, data);
}
