import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/ui/components/dashboard_custom_appbar.dart';
import 'package:swapxchange/ui/home/tabs/profile/sections/settings/settings.dart';
import 'package:swapxchange/ui/home/tabs/profile/sections/wallet/how_to_get_coins.dart';
import 'package:swapxchange/ui/home/tabs/profile/widgets/get_coin_widget.dart';
import 'package:swapxchange/ui/home/tabs/profile/widgets/profile_list_item.dart';
import 'package:swapxchange/ui/home/tabs/profile/widgets/user_details_widget.dart';
import 'package:swapxchange/utils/constants.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            DashboardCustomAppbar(
              title: '',
              icon: Icons.settings,
              iconClick: () => Get.to(() => Settings()),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: Constants.PADDING),
                children: [
                  UserDetailsWidget(),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      GetCoinWidget(),
                    ],
                  ),
                  SizedBox(height: 24),
                  ProfileItem(
                    icon: Icons.add_business,
                    text: 'Top up my wallet',
                    showArrowRight: true,
                    onClick: () => Get.to(() => HowToGetCoins()),
                  ),
                  ProfileItem(
                    icon: Icons.pets,
                    text: 'All my products',
                    showArrowRight: true,
                    onClick: () => null,
                  ),
                  ProfileItem(
                    icon: Icons.credit_card_rounded,
                    text: 'My saved products',
                    showArrowRight: true,
                    onClick: () => Get.to(() => Settings()),
                  ),
                  ProfileItem(
                    icon: Icons.share,
                    text: 'Invite friends',
                    showArrowRight: true,
                    onClick: () => null,
                  ),
                  ProfileItem(
                    icon: Icons.phone,
                    text: 'Rate our App',
                    showArrowRight: true,
                    onClick: () => null,
                  ),
                  ProfileItem(
                    icon: Icons.subject,
                    text: 'Give a feedback',
                    showBottomBorder: false,
                    onClick: () => null,
                  ),
                  ProfileItem(
                    icon: Icons.policy,
                    text: 'Privacy Policy',
                    showBottomBorder: false,
                    onClick: () => null,
                  ),
                  ProfileItem(
                    icon: Icons.question_answer_outlined,
                    text: 'Frequently asked questions',
                    showBottomBorder: false,
                    onClick: () => null,
                  ),
                  ProfileItem(
                    icon: Icons.info_outlined,
                    text: 'About swapXchange',
                    showBottomBorder: true,
                    onClick: () => null,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
