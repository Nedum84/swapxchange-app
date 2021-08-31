import 'package:dio/dio.dart';
import 'package:swapxchange/models/faq_model.dart';
import 'package:swapxchange/repository/dio/api_client.dart';

class RepoFaq extends ApiClient {
  static Future<FaqModel?> addFaqModel({required FaqModel faq}) async {
    try {
      Response response = await ApiClient.request().post('/faqs', data: faq.toMap());

      if (response.statusCode == 200 || response.statusCode == 201) {
        return FaqModel.fromMap(response.data["data"]["faq"]);
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<FaqModel?> editFaqModel({required FaqModel faq}) async {
    try {
      Response response = await ApiClient.request().patch('/faqs/${faq.faqId}', data: faq.toMap());

      if (response.statusCode == 200 || response.statusCode == 201) {
        return FaqModel.fromMap(response.data["data"]["faq"]);
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<FaqModel?> getFaqModelById({required int faqId}) async {
    try {
      Response response = await ApiClient.request().get('/faqs/$faqId');

      if (response.statusCode == 200) {
        return FaqModel.fromMap(response.data["data"]["faq"]);
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  static Future<List<FaqModel>?> findAll() async {
    try {
      Response response = await ApiClient.request().get('/faqs/all');

      if (response.statusCode == 200) {
        var items = response.data["data"]["faq"];

        var list = (items as List).map((data) => FaqModel.fromMap(data)).toList();
        return list;
      }
    } catch (e) {
      print(e);
    }

    return null;
  }
}
