import 'package:dio/dio.dart';
import 'package:swapxchange/models/coins_model.dart';
import 'package:swapxchange/repository/dio/api_client.dart';
import 'package:swapxchange/repository/dio/error_catch.dart';

class RepoCoins extends ApiClient {
  static Future<CoinsModel?> addCoin({required Map payload}) async {
    Response response = await ApiClient.request().post('/coins', data: payload);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return CoinsModel.fromMap(response.data["data"]);
    }
    return null;
  }

  static Future<CoinsModel?> addCoinForUser({required CoinsModel coinsModel, required int userId}) async {
    Response response = await ApiClient.request().post('/coins/$userId', data: coinsModel.toJson());

    if (response.statusCode == 200 || response.statusCode == 201) {
      return CoinsModel.fromMap(response.data["data"]);
    }
    return null;
  }

  static Future<CoinsModel?> getBalance() async {
    try {
      Response response = await ApiClient.request().get('/coins/me');
      if (response.statusCode == 200) {
        // print(CoinsModel.fromMap(response.data["data"]).toMap());

        return CoinsModel.fromMap(response.data["data"]);
      }
    } catch (e) {
      print(e);
      // catchErrors(e);
    }

    return null;
  }

  static Future<CoinsModel?> findAllByUserId({required int userId}) async {
    try {
      Response response = await ApiClient.request().get('/coins/$userId');
      if (response.statusCode == 200) {
        return CoinsModel.fromMap(response.data["data"]);
      }
    } catch (e) {
      catchErrors(e);
    }

    return null;
  }
}
