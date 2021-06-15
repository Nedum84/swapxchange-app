import 'package:flutter/material.dart';
import 'package:swapxchange/controllers/coins_controller.dart';
import 'package:swapxchange/models/coins_model.dart';
import 'package:swapxchange/ui/components/custom_button.dart';
import 'package:swapxchange/utils/alert_utils.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/styles.dart';

class DailyCoins extends StatelessWidget {
  final CoinsController coinsController = CoinsController.to;
  _getDailyCoins() async {
    AlertUtils.showProgressDialog();
    final addCoins = await coinsController.addCoin(amount: CoinsController.dailyLimitCoinsAmount, methodOfSub: MethodOfSubscription.DAILY_OPENING);
    AlertUtils.hideProgressDialog();
    if (addCoins != null) {
      AlertUtils.alert(
        'You have successfully been rewarded with ${CoinsController.dailyLimitCoinsAmount} coins for opening your app today. Keep shopping/swapping at swapXchange.',
        title: 'Success!',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Constants.PADDING,
        horizontal: 24,
      ),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Image.asset(
            'images/logo.jpg',
            width: 60,
          ),
          SizedBox(height: 16),
          Text(
            'Open the app every day',
            style: H2Style,
          ),
          SizedBox(height: 16),
          Text(
            'Open SwapXchange app every day and get free 10 coins and secret gifts for special days!',
            style: StyleNormal,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ButtonSmall(
            onClick: _getDailyCoins,
            text: 'Get ${CoinsController.dailyLimitCoinsAmount} Coins',
            textColor: Colors.white,
            bgColor: KColors.PRIMARY,
            radius: 8,
            py: 8,
          )
        ],
      ),
    );
  }
}
