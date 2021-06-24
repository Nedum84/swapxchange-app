import 'package:dio/dio.dart';
import 'package:swapxchange/repository/dio/api_client.dart';

class RepoProductViews extends ApiClient {
  static Future<bool> addProductView({required int productId}) async {
    try {
      Response response = await ApiClient.request().post('/productviews', data: {"product_id": productId});

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  static Future<List?> findAll({productId}) async {
    try {
      Response response = await ApiClient.request().get('/productviews/$productId');

      if (response.statusCode == 200) {
        return response.data["data"]["views"] as List;
      }
    } catch (e) {
      print(e);
    }
    return [];
  }
}
