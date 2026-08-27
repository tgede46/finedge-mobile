import 'package:dio/dio.dart';

/// Client HTTP vers le backend FastAPI (`finedge-backend`).
///
/// Branchement réel des endpoints à partir des stories auth / sync.
class ApiClient {
  ApiClient({Dio? dio, String baseUrl = defaultBaseUrl})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 15),
              headers: const {'Accept': 'application/json'},
            ),
          );

  static const String defaultBaseUrl = 'https://api.finedge.africa';

  final Dio _dio;

  Dio get dio => _dio;
}
