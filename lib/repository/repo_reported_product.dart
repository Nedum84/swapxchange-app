import 'package:dio/dio.dart';
import 'package:swapxchange/models/reported_product_model.dart';
import 'package:swapxchange/repository/dio/api_client.dart';

class RepoReportedProduct extends ApiClient {
  static Future<ReportedProductModel?> addReportedProductModel({required ReportedProductModel reported_product}) async {
    try {
      Response response = await ApiClient.request().post('/reportedproducts', data: reported_product.toMap());

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ReportedProductModel.fromMap(response.data["data"]["reported_product"]);
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<ReportedProductModel?> editReportedProductModel({required ReportedProductModel reportedProduct}) async {
    try {
      Response response = await ApiClient.request().patch('/reportedproducts/${reportedProduct.id}', data: reportedProduct.toMap());

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ReportedProductModel.fromMap(response.data["data"]["reported_product"]);
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<ReportedProductModel?> getReportedProductModelById({required int catId}) async {
    try {
      Response response = await ApiClient.request().get('/reportedproducts/$catId');

      if (response.statusCode == 200) {
        return ReportedProductModel.fromMap(response.data["data"]["reported_product"]);
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  static Future<List<ReportedProductModel>?> findAll() async {
    try {
      Response response = await ApiClient.request().get('/reportedproducts/all');

      if (response.statusCode == 200) {
        var items = response.data["data"]["reported_product"];

        var list = (items as List).map((data) => ReportedProductModel.fromMap(data)).toList();
        return list;
      }
    } catch (e) {
      print(e);
    }

    return null;
  }
}
