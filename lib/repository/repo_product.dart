import 'package:dio/dio.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/repository/dio/api_client.dart';
import 'package:swapxchange/repository/dio/error_catch.dart';

class RepoProduct extends ApiClient {
  static Future<Product?> getById({required int productId}) async {
    Response response = await ApiClient.request().get('/products/$productId');

    if (response.statusCode == 200) {
      return Product.fromMap(response.data["data"]["product"]);
    }

    return null;
  }

  static void getProducts({
    required Function(List<Product> data) onSuccess,
    required Function(ErrorResponse error) onError,
  }) async {
    ApiClient.request().get('/products/all').then((response) {
      try {
        if (response.data != null) {
          var items = response.data["data"]["products"];

          var list = (items as List).map((data) => Product.fromMap(data)).toList();
          onSuccess(list);
        }
      } catch (e) {
        print(e);
        onSuccess([]);
      }
    }).catchError((error) {
      onError(catchErrors(error));
    });
  }

  static Future<List<Product>?> findAll({limit, offset}) async {
    Response response = await ApiClient.request().get('/products/all/$offset/$limit');

    print(response.data);
    if (response.statusCode == 200) {
      var items = response.data["data"]["products"];

      var list = (items as List).map((data) => Product.fromMap(data)).toList();
      return list;
    }

    return null;
  }
}
