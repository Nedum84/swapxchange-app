import 'package:dio/dio.dart';
import 'package:swapxchange/repository/dio/api_client.dart';
import 'package:swapxchange/utils/alert_utils.dart';

class RepoAppSettings extends ApiClient {
  static Future<String?> editAppSettings({required String key, required String value}) async {
    try {
      Response response = await ApiClient.request().post('/appsettings', data: {"key": key, "value": value});

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data["data"]["about_us"]["value"];
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<String?> getAppSettingsByKey({required String key}) async {
    String? resp;
    try {
      Response response = await ApiClient.request().get('/appsettings/$key');

      if (response.statusCode == 200) {
        return response.data["data"]["$key"]["value"];
      }
    } catch (error) {
      print(error);
      if (error is DioError) {
        if (error.type == DioErrorType.connectTimeout) {
          AlertUtils.toast('No internet connection');
          resp = 'No internet connection';
        }
      } else {
        resp = "Network error.";
      }
    }

    return resp;
  }
}
