import 'package:dio/dio.dart';
import 'package:swapxchange/models/product_image.dart';
import 'package:swapxchange/repository/dio/api_client.dart';

class RepoProductImage {
  static Future<ProductImage?> upsertProductImage({required ProductImage productImage}) async {
    try {
      Response response = await ApiClient.request().post('/productimage', data: productImage.toMap());

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ProductImage.fromMap(response.data["data"]["image_product"]);
      }
    } on Exception catch (e) {
      print(e);
    }
  }
}
