import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/coins_controller.dart';
import 'package:swapxchange/ui/components/custom_button.dart';
import 'package:swapxchange/ui/home/tabs/profile/sections/wallet/wallet_history.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/styles.dart';

class WalletBalance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CoinsController>(builder: (coinsController) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        padding: EdgeInsets.all(Constants.PADDING),
        transform: Matrix4.translationValues(0.0, -40.0, 0.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          children: [
            Image.asset(
              'images/coins_icon.png',
              width: 32,
            ),
            SizedBox(width: 6),
            Column(
              children: [
                Text(
                  '${coinsController.myCoins!.balance!}',
                  style: H2Style.copyWith(
                    color: Colors.black,
                    fontSize: 22,
                  ),
                ),
                Text(
                  'Coins',
                  style: StyleNormal.copyWith(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Spacer(),
            ButtonOutline2(
              onClick: () => Get.to(() => WalletHistory()),
              title: 'History',
              titleColor: Colors.black,
              borderColor: KColors.PRIMARY,
              py: 8,
            )
          ],
        ),
      );
    });
  }
}
