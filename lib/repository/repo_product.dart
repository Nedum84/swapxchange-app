import 'package:dio/dio.dart';
import 'package:swapxchange/models/app_user.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/repository/dio/api_client.dart';
import 'package:swapxchange/repository/dio/error_catch.dart';

class RepoProduct extends ApiClient {
  static Future<Product?> createProduct({required Product product}) async {
    final pMap = product.toMap();
    pMap.update("product_status", (value) => "$value");
    pMap.removeWhere((key, value) => value == null || value == "");

    //remove later
    // pMap.removeWhere((key, value) => key == "order_id" || key == "user_id" || key == "suggestions" || key == "product_id");

    //remove unwanted images keys
    final images = product.images?.map((e) {
      final img = e.toMap();
      img.removeWhere((key, value) => value == null);
      // img.removeWhere((key, value) =>key == "product_id" || key == "image_id");
      return img;
    }).toList();
    pMap.update('images', (value) => images);

    try {
      Response response = await ApiClient.request().post('/products', data: pMap);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Product.fromMap(response.data["data"]["product"]);
      }
    } catch (e) {
      print(e);
    }
  }

  //--> Edit product
  static Future<Product?> updateProduct({required Product product}) async {
    final payload = {
      "product_name": product.productName,
      "category": product.category,
      "sub_category": product.subCategory,
      "price": product.price,
      "product_description": product.productDescription,
      "product_suggestion": product.productSuggestion,
      "product_condition": product.productCondition,
      "product_status": "${Product.statusFromEnum(product.productStatus!)}",
      "user_address": product.userAddress,
      "user_address_city": product.userAddressCity,
      "user_address_lat": product.userAddressLat,
      "user_address_long": product.userAddressLong,
    };

    try {
      Response response = await ApiClient.request().patch('/products/${product.productId}', data: payload);

      if (response.statusCode == 200) {
        return Product.fromMap(response.data["data"]["product"]);
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<Product?> getById({required String productId}) async {
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
    ApiClient.request().get('/products').then((response) {
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
    Response response = await ApiClient.request().get('/products?offset=$offset&limit=$limit');

    if (response.statusCode == 200) {
      var items = response.data["data"]["products"];

      var list = (items as List).map((data) => Product.fromMap(data)).toList();
      return list;
    }

    return null;
  }

  //--> Find by Sub Category
  static Future<List<Product>?> findBySubCategory({required String subCatId, limit, offset, filter}) async {
    final filters = (filter == null) ? "newest" : "$filter";
    Response response = await ApiClient.request().get('/products/subcategory/$subCatId?filters=$filters&offset=$offset&limit=$limit');

    if (response.statusCode == 200) {
      var items = response.data["data"]["products"];

      var list = (items as List).map((data) => Product.fromMap(data)).toList();
      return list;
    }

    return null;
  }

  //--> Find by Category
  static Future<List<Product>?> findByCategory({required String catId, limit, offset}) async {
    Response response = await ApiClient.request().get('/products/category/$catId?offset=$offset&limit=$limit');

    if (response.statusCode == 200) {
      var items = response.data["data"]["products"];

      var list = (items as List).map((data) => Product.fromMap(data)).toList();
      return list;
    }

    return null;
  }

  //--> Find My Products
  static Future<List<Product>?> findMyProducts({limit = 1000, offset = 0}) async {
    Response response = await ApiClient.request().get('/products/me?offset=$offset&limit=$limit');

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

  //--> Find by User's ID
  static Future<List<Product>?> findByUserId({required String userId, filters = "all", limit = 1000, offset = 0}) async {
    Response response = await ApiClient.request().get('/products/user/$userId?filters=$filters&offset=$offset&limit=$limit');

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
  static Future<List<Product>?> findExchangeOptions({required String productId, limit = 1000, offset = 0}) async {
    try {
      Response response = await ApiClient.request().get('/products/exchange/$productId?offset=$offset&limit=$limit');

      if (response.statusCode == 200) {
        var items = response.data["data"]["products"];

        var list = (items as List).map((data) => Product.fromMap(data)).toList();
        return list;
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  //--> Find Nearby Users
  static Future<List<AppUser>?> findNearByUsers({required String productId}) async {
    try {
      Response response = await ApiClient.request().get('/products/nearbyusers/$productId');

      if (response.statusCode == 200) {
        var items = response.data["data"]["users"];
        var list = (items as List)
            .map(
              (json) => AppUser(
                userId: json["user_id"],
                name: json["name"],
                deviceToken: json["device_token"],
                notification: NotificationSetting.fromMap(json["notification"]),
              ),
            )
            .toList();
        return list;
      }
    } catch (e) {
      print(e);
    }

    return null;
  }
}
