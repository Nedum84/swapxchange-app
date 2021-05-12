import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dio_client.dart';

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
    String token = await getToken();
    print('REQUEST[${options.method}] => PATH: ${options.path}');

    options.baseUrl = 'https://jsonplaceholder.typicode.com';
    options.connectTimeout = 5000;
    options.receiveTimeout = 3000;
    // Transform response data to Json Map
    options.responseType = ResponseType.json;
    //Add headers
    customHeaders["Authorization"] = "Bearer $token";
    options.headers.addAll(customHeaders);

    if (token == null) {
      print('no token，request token firstly...');
      dio.lock();
      tokenDio.get('/token').then((d) {
        // continue request...
        options.headers['Authorization'] = token = d.data['data']['token'];
        handler.next(options);
      }).catchError((error, stackTrace) {
        handler.reject(error, true);
      }).whenComplete(() => dio.unlock()); // unlock the dio
    } else {
      options.headers['Authorization'] = "Bearer $token";
      return handler.next(options);
    }
    return super.onRequest(options, handler);
  }

  @override
  onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    // if (response.statusCode == 200 || response.statusCode == 201) {
    //   try {
    //     // response.data = json.decode(response.data);
    //     handler.next(response);
    //   } catch (e) {
    //     print(e);
    //   }
    // }

    return super.onResponse(response, handler);
  }

  @override
  onError(DioError dioError, ErrorInterceptorHandler handler) async {
    print('ERROR[${dioError.response?.statusCode}]');
    if (CancelToken.isCancel(dioError)) {
      print('User cancelled the request');
    }
    //Redirect to login
    if (dioError.message.contains("ERROR_001")) {
      // this will push a new route and remove all the routes that were present
      // navigatorKey.currentState.pushNamedAndRemoveUntil(
      //     "/login", (Route<dynamic> route) => false);
      return;
    }

    // Assume 401 stands for token expired
    if (dioError.response?.statusCode == 401) {
      String token = await getToken();
      bool isLoggedIn = (await SharedPreferences.getInstance()).getBool('key')!;
      bool isRefreshTokenEmpty = false;
      if (!isLoggedIn || isRefreshTokenEmpty) {
        return handler.next(dioError);
      }
      var options = dioError.response!.requestOptions;
      // If the token has been updated, repeat directly.
      if (token != options.headers['refresh_token']) {
        options.headers['Authorization'] = "Bearer $token";
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
      await tokenDio.get('/token').then((d) {
        //update csrfToken
        options.headers['Authorization'] = token = d.data['data']['token'];
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
    // print(dioError.error);
    return super.onError(dioError, handler);
  }

  //Another approach on how to get refresh token
  _customGetToken2(DioError dioError, ErrorInterceptorHandler handler) async {
    // Do something with response error
    if (dioError.response?.statusCode == 403) {
      // update token and repeat
      // Lock to block the incoming request until the token updated
      dio.lock();
      dio.interceptors.requestLock.lock();
      dio.interceptors.responseLock.lock();
      dio.interceptors.errorLock.lock();
      RequestOptions options = dioError.response!.requestOptions;
      Response tokenRes = await tokenDio.get('/token');
      if (tokenRes != null) {
        String token = tokenRes.data['data']['token'];
        options.headers["Authorization"] = "Bearer " + token;

        dio.interceptors.requestLock.unlock();
        dio.interceptors.responseLock.unlock();
        dio.fetch(options).then(
          (r) => handler.resolve(r),
          onError: (e) {
            handler.reject(e);
          },
        );
      } else {
        handler.reject(DioError(requestOptions: options));
      }
      return;
    }
  }
}
