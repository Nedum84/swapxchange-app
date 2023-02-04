import 'package:dio/dio.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/repository/dio/api_client.dart';

class RepoProductSearch extends ApiClient {
  static Future<List<String>> findSearchSuggestions({required String query}) async {
    Response response = await ApiClient.request().get('/products/search/suggest?search_query=$query');

    if (response.statusCode == 200) {
      var suggestions = response.data["data"]["suggestions"];

      var list = (suggestions as List).map((data) => data["item"].toString()).toList();
      return list;
    }

    return [];
  }

  //--> Find by search
  static Future<List<Product>?> findBySearch({required String query, required String filters, limit, offset}) async {
    Response response = await ApiClient.request().get('/products/search?search_query=$query&filters=$filters&offset=$offset&limit=$limit');

    if (response.statusCode == 200) {
      var items = response.data["data"]["products"];

      var list = (items as List).map((data) => Product.fromMap(data)).toList();
      return list;
    }

    return null;
  }
}
