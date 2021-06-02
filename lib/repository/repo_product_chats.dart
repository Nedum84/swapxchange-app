import 'package:dio/dio.dart';
import 'package:swapxchange/models/product_chats.dart';
import 'package:swapxchange/repository/dio/api_client.dart';
import 'package:swapxchange/repository/dio/error_catch.dart';

class RepoProductChats extends ApiClient {
  static Future<ProductChats?> createOne({required ProductChats productChats}) async {
    Response response = await ApiClient.request().post('/productchats', data: productChats.toJson());

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ProductChats.fromMap(response.data["data"]["product_chat"]);
    }
    return null;
  }

  static Future<ProductChats?> findRecentBwTwoUsers({required int secondUserId}) async {
    try {
      Response response = await ApiClient.request().get('/productchats/user/$secondUserId');
      if (response.statusCode == 200) {
        return ProductChats.fromMap(response.data["data"]["product_chat"]);
      }
    } catch (e) {
      catchErrors(e);
    }

    return null;
  }

  static Future<List<ProductChats>?> findAll() async {
    Response response = await ApiClient.request().get('/productchats/all');

    if (response.statusCode == 200) {
      var items = response.data["data"]["product_chat"];

      var list = (items as List).map((data) => ProductChats.fromMap(data)).toList();
      return list;
    }

    return null;
  }
}
