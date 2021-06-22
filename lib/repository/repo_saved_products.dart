import 'package:dio/dio.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/repository/dio/api_client.dart';

class RepoSavedProducts extends ApiClient {
  static Future<bool> savedProduct({required int productId}) async {
    try {
      Response response = await ApiClient.request().post('/saved', data: {"product_id": productId});

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
    } on Exception catch (e) {
      print(e);
    }
    return false;
  }

  //--> Check saved products
  static Future<bool> checkSaved({required int productId}) async {
    try {
      Response response = await ApiClient.request().get('/saved/$productId');
      if (response.statusCode == 200) {
        return response.data["data"]["is_saved"];
      }
    } on Exception catch (e) {
      print(e);
    }
    return false;
  }

  //--> Remove saved products
  static Future<bool> removeSaved({required int productId}) async {
    try {
      Response response = await ApiClient.request().delete('/saved/$productId');
      if (response.statusCode == 200) {
        return true;
      }
    } on Exception catch (e) {
      print(e);
    }
    return false;
  }

  static Future<List<Product>?> findAll({limit, offset}) async {
    Response response = await ApiClient.request().get('/saved/all/$offset/$limit');

    if (response.statusCode == 200) {
      var items = response.data["data"]["products"];

      var list = (items as List).map((data) => Product.fromMap(data)).toList();
      return list;
    }
  }
}