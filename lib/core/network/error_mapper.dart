import 'package:dio/dio.dart';
import 'package:gramophone/core/network/failure.dart';

Failure mapDioErrorToFailure(Object error) {
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutFailure();

      case DioExceptionType.connectionError:
        return NetworkFailure();

      case DioExceptionType.badResponse:
        final data = error.response?.data;
        String message = 'Error Server';
        if (data is Map && data['message'] != null) {
          message = data['message'].toString();
        }
        return ServerFailure(message);
      case DioExceptionType.cancel:
        return NetworkFailure('Request for license cancellation');

      case DioExceptionType.unknown:
        return UnknownFailure('An unknown error occurred: ${error.message}');

      case DioExceptionType.badCertificate:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
  return NetworkFailure('An unknown error occurred');
}
