import 'dart:io';

import 'package:dio/dio.dart';

import 'models/failure_model.dart';

class NetworkException implements Exception {
  NetworkException.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        message = 'Request was cancelled';
        break;
      case DioExceptionType.connectionTimeout:
        message = 'Connection timed out';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Receiving timeout occurred';
        break;
      case DioExceptionType.sendTimeout:
        message = 'Request send timeout';
        break;
      case DioExceptionType.badResponse:
        message = _handleStatusCode(
          dioError.response?.statusCode,
          dioError.response?.data as Map<String, dynamic>,
        );
        break;
      case DioExceptionType.badCertificate:
        message = 'Bad certificate';
        break;
      case DioExceptionType.connectionError:
        message = 'Connection error';
        break;
      case DioExceptionType.unknown:
        if (dioError.error is SocketException) {
          message = 'No Internet.';
          break;
        }
        message = 'Unexpected error occurred';
        break;
    }
  }
  late final String message;

  String _handleStatusCode(int? statusCode, Map<String, dynamic> errorBody) {
    switch (statusCode) {
      case 400:
        return 'Bad Request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not Found';
      case 405:
        return 'Method Not Allowed';
      case 415:
        return 'Unsupported Media Type';
      case 422:
        return 'Unprocessable Entity';
      case 429:
        return 'Too Many Requests';
      case 500:
        return FailureModel.fromJson(errorBody).message;
      default:
        return 'Unknown Error';
    }
  }
}
