import 'package:dio/dio.dart';
import 'package:swapxchange/models/product_image.dart';
import 'package:swapxchange/repository/dio/api_client.dart';

class RepoProductImage {
  static Future<ProductImage?> create({required ProductImage productImage}) async {
    final imgMap = productImage.toMap();
    imgMap.removeWhere((key, value) => value == null || value == "");

    try {
      Response response = await ApiClient.request().post('/productimage', data: imgMap);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ProductImage.fromMap(response.data["data"]["image_product"]);
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<ProductImage?> updateIndex({required ProductImage productImage}) async {
    final payload = {
      "idx": productImage.idx,
    };
    try {
      Response response = await ApiClient.request().patch('/productimage/${productImage.imageId}', data: payload);

      if (response.statusCode == 200) {
        return ProductImage.fromMap(response.data["data"]["image_product"]);
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<bool> delete({required ProductImage productImage}) async {
    try {
      Response response = await ApiClient.request().delete('/productimage/${productImage.imageId}');

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print(e);
    }

    return false;
  }
}
