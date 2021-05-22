import 'package:dio/dio.dart';
import 'package:get/get.dart' as GetX;
import 'package:swapxchange/models/tokens.dart';
import 'package:swapxchange/ui/auth/login.dart';
import 'package:swapxchange/utils/alert_utils.dart';
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
        AlertUtils.toast('Your session has expired. Login again');
        GetX.Get.offAll(() => Login());
        return handler.next(dioError);
      }
      //request options...
      var options = dioError.response!.requestOptions;
      var baseUrl = dioError.response!.requestOptions.baseUrl;
      // update token and repeat
      // Lock to block the incoming request until the token updated
      dio.lock();
      dio.interceptors.requestLock.lock();
      dio.interceptors.responseLock.lock();
      dio.interceptors.errorLock.lock();
      await tokenDio.post('${baseUrl}token/refresh', data: {
        "refresh_token": tokens?.refresh?.token,
      }).then((d) {
        if (d.statusCode != 200 || !d.data['success']) {
          return handler.reject(dioError);
        }
        Tokens tks = Tokens.fromMap(d.data["data"]["tokens"]);
        //Set tokens...
        UserPrefs.setTokens(tokens: tks);
        // Attach token...
        options.headers['Authorization'] = "Bearer ${tks.access!.token}";
      }).whenComplete(() {
        dio.unlock();
        dio.interceptors.responseLock.unlock();
        dio.interceptors.requestLock.unlock();
        dio.interceptors.errorLock.unlock();
      }).then((e) {
        // Repeat request...
        dio.fetch(options).then(
          (r) => handler.resolve(r),
          onError: (e) {
            handler.reject(e);
          },
        );
      }).catchError((er) {
        handler.reject(dioError);
      });
      return;
    }
    return super.onError(dioError, handler);
  }
}
