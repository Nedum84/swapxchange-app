import 'package:flutter/material.dart';
import 'package:swapxchange/ui/home/tabs/profile/sections/wallet/widgets/buy_coins.dart';
import 'package:swapxchange/ui/home/tabs/profile/sections/wallet/widgets/daily_coins.dart';
import 'package:swapxchange/ui/home/tabs/profile/sections/wallet/widgets/invite_friends.dart';
import 'package:swapxchange/ui/home/tabs/profile/sections/wallet/widgets/wallet_balance.dart';
import 'package:swapxchange/ui/home/tabs/profile/sections/wallet/widgets/watch_videos.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/styles.dart';

class HowToGetCoins extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.WHITE_GREY2,
      appBar: AppBar(
        toolbarHeight: 40,
        elevation: 0,
        backgroundColor: KColors.PRIMARY,
        shadowColor: Colors.transparent,
        title: Text(
          'Wallet',
          style: H1Style.copyWith(color: Colors.white),
        ),
      ),
      body: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: KColors.PRIMARY,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(200),
                bottomLeft: Radius.circular(200),
              ),
            ),
          ),
          WalletBalance(),
          Container(
            transform: Matrix4.translationValues(0.0, -20.0, 0.0),
            padding: EdgeInsets.symmetric(horizontal: Constants.PADDING),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Constants.PADDING),
                  child: Text(
                    'Coins are internal currency of SwapXchange. Use coins to make deals and to sell your products.',
                    textAlign: TextAlign.center,
                    style: StyleNormal.copyWith(
                      color: KColors.TEXT_COLOR_LIGHT,
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'How to get coins',
                  style: H1Style.copyWith(),
                ),
                SizedBox(height: 24),
                DailyCoins(),
                InviteFriends(),
                BuyCoins(),
                WatchVideos()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
