import 'package:dio/dio.dart';

import '../../controller/storage/storage.dart';
import '../../flavors.dart';
import '../env/environment.dart';
import 'api_response.dart';

class ApiException implements Exception {
  final String message;
  final int? code;
  ApiException(this.message, {this.code});
}

class ApiClient {
  ApiClient({Dio? dio}) : _dio = dio ?? _buildDio();

  final Dio _dio;
  final _storage = LocalStorage();

  static Dio _buildDio() {
    return Dio(
      BaseOptions(
        baseUrl: Environment.baseUrl.isNotEmpty ? Environment.baseUrl : F.baseUrl,
        connectTimeout: const Duration(seconds: 40),
        receiveTimeout: const Duration(seconds: 40),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }

  Future<Options> _authOptions() async {
    final token = await _storage.readData(LocalStorage.token);
    return Options(headers: token == null ? null : {'Authorization': 'Bearer $token'});
  }

  Future<ApiResponse<T>> _send<T>(
    Future<Response> Function(Options options) request,
    T Function(dynamic json) fromJson, {
    bool retryAfterRefresh = true,
  }) async {
    try {
      final response = await request(await _authOptions());
      return ApiResponse.success(fromJson(response.data['data']));
    } on DioException catch (error) {
      if (error.response?.statusCode == 401 && retryAfterRefresh) {
        final refreshed = await _refreshToken();
        if (refreshed) {
          return _send(request, fromJson, retryAfterRefresh: false);
        }
      }
      return ApiResponse.error(
        message: _messageFor(error),
        code: error.response?.statusCode,
      );
    }
  }

  String _messageFor(DioException error) {
    final isTimeoutOrConnection = [
      DioExceptionType.connectionTimeout,
      DioExceptionType.receiveTimeout,
      DioExceptionType.sendTimeout,
      DioExceptionType.connectionError,
    ].contains(error.type);
    if (isTimeoutOrConnection) {
      return 'Network error occurred, Please try again.';
    }
    return error.response?.data?['message'] ?? 'An unknown error occurred';
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _storage.readData(LocalStorage.refreshToken);
      if (refreshToken == null) return false;
      final response = await _dio.post(
        'auth/token/refresh',
        data: {'refreshToken': refreshToken},
      );
      final success = response.data['success'] == true;
      if (success) {
        await _storage.writeData(LocalStorage.token, response.data['data']['token']);
        await _storage.writeData(
          LocalStorage.refreshToken,
          response.data['data']['refreshToken'],
        );
      }
      return success;
    } on DioException {
      return false;
    }
  }

  Future<ApiResponse<T>> get<T>(
    String endpoint,
    T Function(dynamic json) fromJson, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _send(
      (options) => _dio.get(endpoint, queryParameters: queryParameters, options: options),
      fromJson,
    );
  }

  Future<ApiResponse<T>> post<T>(
    String endpoint,
    T Function(dynamic json) fromJson, {
    dynamic data,
  }) {
    return _send((options) => _dio.post(endpoint, data: data, options: options), fromJson);
  }

  Future<ApiResponse<T>> put<T>(
    String endpoint,
    T Function(dynamic json) fromJson, {
    dynamic data,
  }) {
    return _send((options) => _dio.put(endpoint, data: data, options: options), fromJson);
  }

  Future<ApiResponse<T>> delete<T>(
    String endpoint,
    T Function(dynamic json) fromJson, {
    dynamic data,
  }) {
    return _send((options) => _dio.delete(endpoint, data: data, options: options), fromJson);
  }
}
