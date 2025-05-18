import 'package:dio/dio.dart';

enum DataSource {
  success,
  noContent,
  badRequest,
  forbidden,
  unauthorized,
  notFound,
  internalServerError,
  connectTimeout,
  cancel,
  receiveTimeout,
  sendTimeout,
  cacheError,
  noInternetConnection,
  defaultError
}

class ErrorHandler implements Exception {
  late String errorMessage;
  late DataSource dataSource;

  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      // dio error so it's error from response of the API
      _handleError(error);
    } else {
      // default error
      dataSource = DataSource.defaultError;
      errorMessage = error.toString();
    }
  }

  void _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        dataSource = DataSource.connectTimeout;
        errorMessage = "Connection timeout";
        break;
      case DioExceptionType.sendTimeout:
        dataSource = DataSource.sendTimeout;
        errorMessage = "Send timeout";
        break;
      case DioExceptionType.receiveTimeout:
        dataSource = DataSource.receiveTimeout;
        errorMessage = "Receive timeout";
        break;
      case DioExceptionType.badResponse:
        dataSource = _handleResponseError(error.response?.statusCode);
        errorMessage = error.response?.statusMessage ?? "";
        break;
      case DioExceptionType.cancel:
        dataSource = DataSource.cancel;
        errorMessage = "Request was cancelled";
        break;
      case DioExceptionType.unknown:
        dataSource = DataSource.defaultError;
        errorMessage = "Unknown error occurred";
        break;
      default:
        dataSource = DataSource.defaultError;
        errorMessage = "Something went wrong";
        break;
    }
  }

  DataSource _handleResponseError(int? statusCode) {
    switch (statusCode) {
      case 400:
        return DataSource.badRequest;
      case 401:
        return DataSource.unauthorized;
      case 403:
        return DataSource.forbidden;
      case 404:
        return DataSource.notFound;
      case 500:
        return DataSource.internalServerError;
      default:
        return DataSource.defaultError;
    }
  }

  @override
  String toString() {
    return errorMessage;
  }
}

class Failure {
  final DataSource dataSource;
  final String message;

  const Failure(this.dataSource, this.message);
}
