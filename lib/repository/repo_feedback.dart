import 'package:dio/dio.dart';
import 'package:swapxchange/models/feedback_model.dart';
import 'package:swapxchange/repository/dio/api_client.dart';

class RepoFeedback extends ApiClient {
  static Future<FeedbackModel?> addFeedbackModel({required FeedbackModel feedback}) async {
    final map = {"message": feedback.message};
    try {
      Response response = await ApiClient.request().post('/feedback', data: map);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return FeedbackModel.fromMap(response.data["data"]["feedback"]);
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<FeedbackModel?> editFeedbackModel({required FeedbackModel feedback}) async {
    try {
      Response response = await ApiClient.request().patch('/feedback/${feedback.feedbackId}', data: feedback.toMap());

      if (response.statusCode == 200 || response.statusCode == 201) {
        return FeedbackModel.fromMap(response.data["data"]["feedback"]);
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<FeedbackModel?> getFeedbackModelById({required int id}) async {
    try {
      Response response = await ApiClient.request().get('/feedback/$id');

      if (response.statusCode == 200) {
        return FeedbackModel.fromMap(response.data["data"]["feedback"]);
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  static Future<List<FeedbackModel>?> findAll() async {
    try {
      Response response = await ApiClient.request().get('/feedback/all');

      if (response.statusCode == 200) {
        var items = response.data["data"]["feedback"];

        var list = (items as List).map((data) => FeedbackModel.fromMap(data)).toList();
        return list;
      }
    } catch (e) {
      print(e);
    }

    return null;
  }
}
