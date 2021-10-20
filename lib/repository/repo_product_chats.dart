import 'package:dio/dio.dart';
import 'package:swapxchange/models/product_chats.dart';
import 'package:swapxchange/repository/dio/api_client.dart';
import 'package:swapxchange/repository/dio/error_catch.dart';

class RepoProductChats extends ApiClient {
  //upsert on the server
  static Future<ProductChats?> createOne({required ProductChats productChats}) async {
    final map = productChats.toMap();
    map.removeWhere((key, value) => value == null || key == "product_images" || key == "product_offer_images" || key == "product_chat_id");

    try {
      Response response = await ApiClient.request().post('/productchats', data: map);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ProductChats.fromMap(response.data["data"]["product_chat"]);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<ProductChats?> findById({required String id}) async {
    Response response = await ApiClient.request().get('/productchats/$id');

    try {
      if (response.statusCode == 200) {
        return ProductChats.fromMap(response.data["data"]["product_chat"]);
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<ProductChats?> findRecentBwTwoUsers({required String secondUserId}) async {
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
