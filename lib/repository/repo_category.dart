import 'package:dio/dio.dart';
import 'package:swapxchange/models/category_model.dart';
import 'package:swapxchange/repository/dio/api_client.dart';

class RepoCategory extends ApiClient {
  static Future<Category?> addCategory({required Category category}) async {
    final map = {
      "category_name": category.categoryName,
      "category_icon": category.categoryIcon,
    };
    try {
      Response response = await ApiClient.request().post('/category', data: map);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Category.fromMap(response.data["data"]["category"]);
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<Category?> editCategory({required Category category}) async {
    final map = {
      "category_name": category.categoryName,
      "category_icon": category.categoryIcon,
    };
    try {
      Response response = await ApiClient.request().patch('/category/${category.categoryId}', data: map);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Category.fromMap(response.data["data"]["category"]);
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<Category?> getCategoryById({required String catId}) async {
    try {
      Response response = await ApiClient.request().get('/category/$catId');

      if (response.statusCode == 200) {
        return Category.fromMap(response.data["data"]["category"]);
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  static Future<List<Category>?> findAll() async {
    try {
      Response response = await ApiClient.request().get('/category');

      if (response.statusCode == 200) {
        var items = response.data["data"]["category"];

        var list = (items as List).map((data) => Category.fromMap(data)).toList();
        return list;
      }
    } catch (e) {
      print(e);
    }

    return null;
  }
}
