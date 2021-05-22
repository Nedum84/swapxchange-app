import 'package:dio/dio.dart';
import 'package:swapxchange/models/category_model.dart';
import 'package:swapxchange/repository/dio/api_client.dart';

class RepoCategory extends ApiClient {
  static Future<Category?> getCategoryById({required int catId}) async {
    Response response = await ApiClient.request().get('/category/$catId');

    if (response.statusCode == 200) {
      return Category.fromMap(response.data["data"]["category"]);
    }

    return null;
  }

  static Future<List<Category>?> findAll() async {
    Response response = await ApiClient.request().get('/category/all');

    if (response.statusCode == 200) {
      var items = response.data["data"]["category"];

      var list = (items as List).map((data) => Category.fromMap(data)).toList();
      return list;
    }

    return null;
  }
}
