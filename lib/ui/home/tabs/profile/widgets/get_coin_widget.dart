import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/coins_controller.dart';
import 'package:swapxchange/ui/home/tabs/profile/sections/wallet/how_to_get_coins.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

class GetCoinWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: KColors.TEXT_COLOR_LIGHT2.withOpacity(.2)),
      ),
      child: Row(
        children: [
          SizedBox(width: 4),
          Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: KColors.PRIMARY,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'C',
              style: StyleNormal.copyWith(
                color: Colors.white70,
                fontSize: 10,
              ),
            ),
          ),
          SizedBox(width: 8),
          GetBuilder<CoinsController>(builder: (controller) {
            return Text(
              '${Get.find<CoinsController>().myCoins!.balance} coins',
              style: StyleNormal,
            );
          }),
          SizedBox(width: 8),
          InkWell(
            onTap: () => Get.to(() => HowToGetCoins()),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: KColors.PRIMARY,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                'Get more',
                style: StyleNormal.copyWith(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
