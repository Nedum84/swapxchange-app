import 'package:get/get.dart';
import 'package:swapxchange/models/coins_model.dart';
import 'package:swapxchange/repository/repo_coins.dart';

class CoinsController extends GetxController {
  static CoinsController to = Get.find();
  static int uploadAmount = 100;
  static int registrationCoinsAmount = 500;
  static int dailyLimitCoinsAmount = 10;
  static int referralCoinsAmount = 50;
  static int watchVideoAmount = 20;
  static int coins500Price = 399;
  static int coins1000Price = 759;
  static int coins5000Price = 2999;
  CoinsModel? _myCoins;

  CoinsModel? get myCoins => _myCoins;

  Future<CoinsModel?> addCoin({required int amount, required MethodOfSubscription methodOfSub, String? ref}) async {
    Map<String, String> payload = {
      "amount": amount.toString(),
      "method_of_subscription": LastCredit.statusFromEnum(methodOfSub),
      "reference": ref ?? "",
    };
    final response = await RepoCoins.addCoin(payload: payload);
    print(response?.toMap());
    if (response != null) {
      updateBalance(response);
    }
    return response;
  }

  Future<CoinsModel?> getBalance() async {
    final response = await RepoCoins.getBalance();
    if (response != null) {
      updateBalance(response);
    }
    return response;
  }

  void updateBalance(CoinsModel coinsModel) {
    _myCoins = coinsModel;
    update();
  }

  void resetBal() {
    _myCoins = null;
    update();
  }

  static int getCoinsFromAmount(int amount) {
    if (amount == coins500Price) {
      return 500;
    } else if (amount == coins1000Price) {
      return 1000;
    } else {
      return 5000;
    }
  }
}
