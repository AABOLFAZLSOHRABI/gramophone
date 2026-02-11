import 'package:dio/dio.dart';
import 'endpoints.dart';

class DioClient {
  late final Dio dio;
  final _audiusHost = Uri.parse(Endpoints.audiusBaseUrl).host;

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: Endpoints.audiusBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Accept': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (options.uri.host == _audiusHost) {
            options.queryParameters.putIfAbsent(
              'api_key',
              () => Endpoints.audiusApiKey,
            );
          }
          handler.next(options);
        },
      ),
    );
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: false));
  }

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? query,
  }) {
    return dio.get(path, queryParameters: query);
  }

  Future<Response<dynamic>> download(
    String url,
    String savePath, {
    Map<String, dynamic>? query,
  }) {
    return dio.download(url, savePath, queryParameters: query);
  }
}
