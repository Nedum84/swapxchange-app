import 'package:dio/dio.dart';
// import 'package:get/get.dart';
import 'package:swapxchange/models/tokens.dart';
import 'package:swapxchange/utils/user_prefs.dart';

class DioCustomInterceptors extends Interceptor {
  final Dio dio;
  DioCustomInterceptors({required this.dio});

//  dio instance to request token
  var tokenDio = Dio();
  var customHeaders = {
    // 'content-type': 'application/json',
    'content-type': Headers.jsonContentType,
    'Accept': Headers.acceptHeader,
  };

  @override
  onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    Tokens? tokens = await UserPrefs.getTokens();
    print('REQUEST[${options.method}] => PATH: ${options.path}');

    options.baseUrl = 'http://127.0.0.1:8088/v1/';
    options.connectTimeout = 5000;
    options.receiveTimeout = 3000;
    // Transform response data to Json Map
    options.responseType = ResponseType.json;
    //Add headers
    customHeaders["Authorization"] = "Bearer ${tokens?.access?.token}";
    options.headers.addAll(customHeaders);

    // if (tokens == null) {
    //   print('no token，request token firstly...');
    //   dio.lock();
    //   tokenDio.post('/token/refresh', data: {
    //     "refresh_token": tokens.refresh.token,
    //   }).then((d) async {
    //     print(d.data);
    //     Tokens tks = Tokens.fromMap(d.data["data"]["tokens"]);
    //     //Set tokens...
    //     UserPrefs.setTokens(tokens: tks);
    //
    //     // continue request...
    //     options.headers['Authorization'] = "Bearer ${tks.access.token}";
    //     handler.next(options);
    //   }).catchError((error, stackTrace) {
    //     handler.reject(error, true);
    //   }).whenComplete(() => dio.unlock()); // unlock the dio
    // } else {
    //   options.headers['Authorization'] = "Bearer ${tokens.access.token}";
    //   return handler.next(options);
    // }
    return super.onRequest(options, handler);
  }

  @override
  onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    return super.onResponse(response, handler);
  }

  @override
  onError(DioError dioError, ErrorInterceptorHandler handler) async {
    print('ERROR[${dioError.response?.statusCode}]');
    print('ERROR[${dioError.response?.data}]');
    if (CancelToken.isCancel(dioError)) {
      print('User cancelled the request');
    }

    // Assume 401 stands for token expired
    if (dioError.response?.statusCode == 401) {
      Tokens? tokens = await UserPrefs.getTokens();
      if (tokens?.refresh == null) {
        print('kkkkkkkkkkkk---');
        // Get.offAll(()=>Login());
        return handler.next(dioError);
      }
      var options = dioError.response!.requestOptions;
      // If the token has been updated, repeat directly.
      if (tokens?.access?.token != options.headers['refresh_token']) {
        options.headers['Authorization'] = "Bearer ${tokens?.access?.token}";
        //repeat
        dio.fetch(options).then(
          (r) => handler.resolve(r),
          onError: (e) {
            handler.reject(e);
          },
        );
        return;
      }
      // update token and repeat
      // Lock to block the incoming request until the token updated
      dio.lock();
      dio.interceptors.requestLock.lock();
      dio.interceptors.responseLock.lock();
      dio.interceptors.errorLock.lock();
      await tokenDio.post('/token/refresh', data: {
        "refresh_token": tokens?.refresh?.token,
      }).then((d) {
        print('kkkkkkkkkkkk');
        print(d.data);
        Tokens tks = Tokens.fromMap(d.data["data"]["tokens"]);
        //Set tokens...
        UserPrefs.setTokens(tokens: tks);

        // continue request...
        options.headers['Authorization'] = "Bearer ${tks.access!.token}";
      }).whenComplete(() {
        dio.unlock();
        dio.interceptors.responseLock.unlock();
        dio.interceptors.requestLock.unlock();
        dio.interceptors.errorLock.unlock();
      }).then((e) {
        //repeat
        dio.fetch(options).then(
          (r) => handler.resolve(r),
          onError: (e) {
            handler.reject(e);
          },
        );
      });
      return;
    }
    return super.onError(dioError, handler);
  }
}
