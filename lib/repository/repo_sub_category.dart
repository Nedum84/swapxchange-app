import 'package:dio/dio.dart';
import 'package:swapxchange/models/sub_category_model.dart';
import 'package:swapxchange/repository/dio/api_client.dart';

class RepoSubCategory extends ApiClient {
  static Future<SubCategory?> getSubCategoryById({required int subCatId}) async {
    try {
      Response response = await ApiClient.request().get('/subcategory/$subCatId');

      if (response.statusCode == 200) {
        return SubCategory.fromMap(response.data["data"]["subcategory"]);
      }
    } on Exception catch (e) {
      print(e);
    }

    return null;
  }

  static Future<List<SubCategory>?> findAll() async {
    try {
      Response response = await ApiClient.request().get('/subcategory/all');

      if (response.statusCode == 200) {
        var items = response.data["data"]["subcategory"];

        var list = (items as List).map((data) => SubCategory.fromMap(data)).toList();
        return list;
      }
    } on Exception catch (e) {
      print(e);
    }

    return null;
  }

  static Future<List<SubCategory>?> findByCategoryId({required int catId}) async {
    try {
      Response response = await ApiClient.request().get('/subcategory/category/$catId');

      if (response.statusCode == 200) {
        var items = response.data["data"]["subcategory"];

        var list = (items as List).map((data) => SubCategory.fromMap(data)).toList();
        return list;
      }
    } on Exception catch (e) {
      print(e);
    }

    return null;
  }
}
