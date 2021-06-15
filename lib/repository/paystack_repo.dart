import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/helpers.dart';

class PaystackRepo {
  //VERIFY SERVER PAYMENT
  static Future<bool> verifyOnServer({required String reference}) async {
    String paystackSecret = Constants.PAYSTACK_SECRET_KEY;
    bool isSuccessful = false;
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $paystackSecret',
      };
      http.Response response = await http.get(Uri.parse('https://api.paystack.co/transaction/verify/' + reference), headers: headers);
      final Map body = json.decode(response.body);
      if (body['data']['status'] == 'success') {
        isSuccessful = true;
      }
      print(response.body);
    } catch (e) {
      print(e);
    }

    return isSuccessful;
  }

  //UNIQUE PAYMENT REFERENCE FOR QUESTIONS
  static String genPaymentReference({required int noOfCoins, required int userId}) {
    return '${Helpers.genRandString(length: 10).toUpperCase()}_${noOfCoins}_$userId';
  }
}
