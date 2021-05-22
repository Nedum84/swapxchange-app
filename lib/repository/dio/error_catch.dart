import 'package:dio/dio.dart';

dynamic catchErrors(error) {
  dynamic resp;
  try {
    resp = error.response?.data!["message"] ?? error;
  } catch (e) {
    resp = error.response?.data!;
  }
  return (resp);
}

class ErrorResponse {
  String? message;
  int type;
  dynamic? error;
  Response? response;

  ErrorResponse({
    required this.message,
    required this.type,
    this.error,
    this.response,
  });
}
