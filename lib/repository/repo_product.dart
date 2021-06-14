import 'package:dio/dio.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/repository/dio/api_client.dart';
import 'package:swapxchange/repository/dio/error_catch.dart';

class RepoProduct extends ApiClient {
  static Future<Product?> createProduct({required Product product}) async {
    try {
      Response response = await ApiClient.request().post('/products', data: product.toMap());

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Product.fromMap(response.data["data"]["product"]);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  //--> Edit product
  static Future<Product?> updateProduct({required Product product}) async {
    try {
      Response response = await ApiClient.request().patch('/products/${product.productId}', data: product.toMap());

      if (response.statusCode == 200) {
        return Product.fromMap(response.data["data"]["product"]);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

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

    if (response.statusCode == 200) {
      var items = response.data["data"]["products"];

      var list = (items as List).map((data) => Product.fromMap(data)).toList();
      return list;
    }

    return null;
  }

  //--> Find by Sub Category
  static Future<List<Product>?> findBySubCategory({required int subCatId, limit, offset, filter}) async {
    final filters = (filter == null) ? "newest" : "$filter";
    Response response = await ApiClient.request().get('/products/subcategory/$subCatId/$offset/$limit/$filters');

    if (response.statusCode == 200) {
      var items = response.data["data"]["products"];

      var list = (items as List).map((data) => Product.fromMap(data)).toList();
      return list;
    }

    return null;
  }

  //--> Find by Category
  static Future<List<Product>?> findByCategory({required int catId, limit, offset}) async {
    Response response = await ApiClient.request().get('/products/category/$catId/$offset/$limit');

    if (response.statusCode == 200) {
      var items = response.data["data"]["products"];

      var list = (items as List).map((data) => Product.fromMap(data)).toList();
      return list;
    }

    return null;
  }

  //--> Find My Products
  static Future<List<Product>?> findMyProducts({limit = 1000, offset = 0}) async {
    Response response = await ApiClient.request().get('/products/me/$offset/$limit');

    if (response.statusCode == 200) {
      var items = response.data["data"]["products"];

      var list = (items as List).map((data) => Product.fromMap(data)).toList();
      return list;
    }

    return null;
  }

  //--> Find by User's ID
  static Future<List<Product>?> findByUserId({required int userId, filters = "all", limit = 1000, offset = 0}) async {
    Response response = await ApiClient.request().get('/products/user/$userId/$filters/$offset/$limit');

    if (response.statusCode == 200) {
      try {
        var items = response.data["data"]["products"];

        var list = (items as List).map((data) => Product.fromMap(data)).toList();
        return list;
      } catch (e) {
        print(e);
      }
    }

    return null;
  }

  //--> Find Exchange Options fo a given product
  static Future<List<Product>?> findExchangeOptions({required int productId, limit = 1000, offset = 0}) async {
    Response response = await ApiClient.request().get('/products/exchange/$productId/$offset/$limit');

    if (response.statusCode == 200) {
      var items = response.data["data"]["products"];

      var list = (items as List).map((data) => Product.fromMap(data)).toList();
      return list;
    }

    return null;
  }
}
