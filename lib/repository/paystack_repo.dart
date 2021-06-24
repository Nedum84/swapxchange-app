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

  //FOR SERVER PAYMENT
  static Future<String?> createAccessCode({required String paymentReference, required int amount, required String email}) async {
    final paystackSecret = Constants.PAYSTACK_SECRET_KEY;
    // paystackSecret -> paystack Secret key
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $paystackSecret',
    };
    Map data = {"amount": amount, "email": email, "reference": paymentReference};
    try {
      String payload = json.encode(data);
      http.Response response = await http.post(Uri.parse('https://api.paystack.co/transaction/initialize'), headers: headers, body: payload);
      final Map _data = jsonDecode(response.body);
      print(response.body);
      String accessCode = _data['data']['access_code'];
      return accessCode;
    } catch (e) {
      print(e);
    }
  }

  //UNIQUE PAYMENT REFERENCE FOR QUESTIONS
  static String genPaymentReference({required int noOfCoins, required int userId}) {
    return '${Helpers.genRandString(length: 10).toUpperCase()}_${noOfCoins}_$userId';
  }
}
