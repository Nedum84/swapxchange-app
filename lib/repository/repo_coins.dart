import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:swapxchange/models/coins_model.dart';
import 'package:swapxchange/repository/dio/api_client.dart';
import 'package:swapxchange/utils/alert_utils.dart';
import 'package:swapxchange/utils/encrypt.dart';
import 'package:swapxchange/utils/firebase_collections.dart';

class RepoCoins extends ApiClient {
  //Create instance
  static CollectionReference coinsCollection = FirebaseFirestore.instance.collection(FirebaseCollection.COINS_COLLECTION);

  static Future<CoinsModel?> addCoin({required Map payload}) async {
    final strPayload = jsonEncode(payload);

    final body = {
      "payload": Encrypt.encrypt(strPayload),
    };

    try {
      Response response = await ApiClient.request().post('/coins', data: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final coinsModel = CoinsModel.fromMap(response.data["data"]);
        //Add coins to firebase oooooo........
        final fbPayload = {
          "id": coinsModel.lastCredit!.id!,
          "user_id": coinsModel.lastCredit!.userId!,
          "amount": coinsModel.lastCredit!.amount!,
          "reference": coinsModel.lastCredit!.reference!,
          "method_of_subscription": LastCredit.statusFromEnum(coinsModel.lastCredit!.methodOfSubscription!),
          "created_at": coinsModel.lastCredit!.createdAt!,
        };
        await coinsCollection.doc().set(fbPayload);
        //Return coins model
        return coinsModel;
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        if (e.response!.data!.containsKey("message")) {
          AlertUtils.toast(e.response!.data["message"] ?? "Network error");
        }
      }
    }
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
      if (response.statusCode == 200 || response.statusCode == 201) {
        return CoinsModel.fromMap(response.data["data"]);
      }
    } catch (e) {
      print(e);
      // catchErrors(e);
    }

    return null;
  }

  static Future<CoinsModel?> findAllByUserId({required String userId, int limit = 500}) async {
    try {
      Response response = await ApiClient.request().get('/coins/$userId?limit=$limit');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return CoinsModel.fromMap(response.data["data"]);
      }
    } catch (e) {
      print(e);
    }
  }
}
