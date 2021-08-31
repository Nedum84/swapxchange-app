import 'package:dio/dio.dart';

dynamic catchErrors(error) {
  dynamic resp;
  try {
    resp = error?.response.data["message"];
  } catch (e) {
    if (error is DioError) {
      if (error.response?.data?.containsKey("message") ?? false) {
        resp = error.response!.data?["message"] ?? "Network error";
      } else {
        resp = "Network error::CODE02";
      }
    } else {
      resp = "Network error.";
    }
  }
  return resp;
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
