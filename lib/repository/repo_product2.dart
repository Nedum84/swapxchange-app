import 'package:dio/dio.dart';
import 'package:swapxchange/models/product_model2.dart';
import 'package:swapxchange/repository/dio/api_client.dart';

class RepoProduct extends ApiClient {
  //Request token for cancelling requests...
  var token = CancelToken();

  Future<void> getProductById() async {
    Response response = await ApiClient.request().get('path');
  }

  //with cancelRequestToken
  Future<void> getProductById2() async {
    Dio client = await ApiClient.request();

    Response response = await client.get('path', cancelToken: token);
  }

  _post() async {
    var response = await ApiClient.request().post(
      '/test',
      data: {'id': 12, 'name': 'wendu'},
      onReceiveProgress: _onReceiveProgress,
      onSendProgress: _onSendProgress,
      options: _dioOptions,
    );
    // response.data;
  }

  _onReceiveProgress(received, total) {}
  _onSendProgress(sent, total) {}
  late Options _dioOptions;

  void downloadFile(String publishSubject) {
    ApiClient.request().download('urlOfFileToDownload', 'dir/filename', onReceiveProgress: (received, total) {
      int percentage = ((received / total) * 100).floor();
    });
  }

  static void getProducts({
    Function()? beforeSend,
    required Function(List<Product2> data) onSuccess,
    required Function(ErrorResponse error) onError,
  }) async {
    if (beforeSend != null) beforeSend();
    ApiClient.request().get('/posts').then((res) {
      try {
        if (res != null && onSuccess != null) {
          onSuccess((res.data as List).map((data) => Product2.fromMap(data)).toList());
        }
      } catch (e) {
        print(e);
        onSuccess([]);
      }
    }).catchError((error) {
      var errResponse = ErrorResponse(message: null, type: 0);
      if (error is DioError) {
        DioError dioError = error;
        switch (dioError.type) {
          case DioErrorType.connectTimeout:
            errResponse.message = "Connection timeout";
            errResponse.type = 1;
            break;
          case DioErrorType.cancel:
            errResponse.message = "Request cancelled";
            break;
          case DioErrorType.sendTimeout:
            errResponse.message = "Request send time out";
            break;
          case DioErrorType.receiveTimeout:
            errResponse.message = "Request receive timeout";
            break;
          case DioErrorType.response:
            errResponse.message = dioError.message;
            break;
          case DioErrorType.other:
            errResponse.message = "Network timeout::ERR" + dioError.message;
            errResponse.error = dioError.error;
            errResponse.response = dioError.response;
            break;
        }
      }
      if (onError != null) onError(errResponse);
    });
  }

  void fetch() async {
    Response<ResponseBody> rs;
    rs = await Dio().get<ResponseBody>(
      'url',
      options: Options(responseType: ResponseType.stream), // set responseType to `stream`
    );
    print(rs.data!.stream);
  }
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
