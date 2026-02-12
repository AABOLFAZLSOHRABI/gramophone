import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'endpoints.dart';

class DioClient {
  late final Dio dio;
  final _audiusHost = Uri.parse(Endpoints.audiusBaseUrl).host;
  final Map<int, Stopwatch> _timers = <int, Stopwatch>{};

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: Endpoints.audiusBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
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
    if (kDebugMode) {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            final key = options.hashCode;
            _timers[key] = Stopwatch()..start();
            debugPrint('HTTP ${options.method} ${options.uri}');
            handler.next(options);
          },
          onResponse: (response, handler) {
            final key = response.requestOptions.hashCode;
            final elapsedMs = _timers.remove(key)?.elapsedMilliseconds ?? -1;
            debugPrint(
              'HTTP ${response.statusCode} ${response.requestOptions.method} '
              '${response.requestOptions.uri} (${elapsedMs}ms)',
            );
            handler.next(response);
          },
          onError: (error, handler) {
            final key = error.requestOptions.hashCode;
            final elapsedMs = _timers.remove(key)?.elapsedMilliseconds ?? -1;
            debugPrint(
              'HTTP ERROR ${error.response?.statusCode ?? '-'} '
              '${error.requestOptions.method} ${error.requestOptions.uri} '
              '(${elapsedMs}ms): ${error.type}',
            );
            handler.next(error);
          },
        ),
      );
    }
  }

  Future<Response<dynamic>> get(String path, {Map<String, dynamic>? query}) {
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
