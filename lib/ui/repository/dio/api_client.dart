import 'package:dio/dio.dart';

import 'dio_custom_interceptors.dart';

class ApiClient {
  // var dio = Dio().interceptors.add(DioCustomInterceptors(dio: this));

  static Dio apiClient() {
    var dio = Dio();
    dio.interceptors.add(DioCustomInterceptors(dio: dio));
    return dio;
  }
}
