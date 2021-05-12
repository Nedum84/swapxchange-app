import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  var customHeaders = {
    'content-type': 'application/json',
    'Accept': 'application/json',
  };

  Future<Dio> dioClient() async {
    var dio = Dio();

    dio
      ..interceptors
          .add(InterceptorsWrapper(onRequest: (options, handler) async {
        String token = await getToken();
        // Do something before request is sent
        customHeaders["Authorization"] = "Bearer $token";
        options.headers.addAll(customHeaders);
        options.baseUrl = "";
        return handler.next(options); //continue
      }, onResponse: (response, handler) {
        // Do something with response data
        return handler.next(response); // continue
      }, onError: (DioError e, handler) {
        // Do something with response error
        return handler.next(e); //continue
      }));

    // Set default configs
    dio.options.baseUrl = 'https://www.xx.com/api';
    dio.options.connectTimeout = 5000; //5s
    dio.options.receiveTimeout = 3000;

    // you can also set headers as...
    // dio.options.headers.addAll(customHeaders);
    // dio.options.headers= {"Authorization" : "Bearer $token"};
    return dio;
  }
}

Future<String> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "urtiyurikhturbutbrilu879846";
  return token;
}
