import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/ui/components/dashboard_custom_appbar.dart';
import 'package:swapxchange/ui/home/tabs/profile/sections/settings/settings.dart';
import 'package:swapxchange/ui/home/tabs/profile/sections/wallet/how_to_get_coins.dart';
import 'package:swapxchange/ui/home/tabs/profile/widgets/get_coin_widget.dart';
import 'package:swapxchange/ui/home/tabs/profile/widgets/profile_list_item.dart';
import 'package:swapxchange/ui/widgets/cached_image.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/styles.dart';

class Profile extends StatelessWidget {
  final UserController userController = UserController.to;

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
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 4),
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          boxShadow: [Constants.SHADOW],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: CachedImage(
                          userController.user!.profilePhoto!,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          radius: 50,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userController.user!.name!,
                                style: H2Style,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Color(0xffCD4F4E).withOpacity(.8),
                                    size: 18,
                                  ),
                                  Expanded(
                                    child: Text(
                                      userController.user!.address!,
                                      style: StyleCategorySubTitle,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      GetCoinWidget(),
                    ],
                  ),
                  SizedBox(height: 24),
                  ProfileItem(
                    icon: Icons.settings,
                    text: 'Get more coins',
                    showArrowRight: true,
                    onClick: () => Get.to(() => HowToGetCoins()),
                  ),
                  ProfileItem(
                    icon: Icons.settings,
                    text: 'All my orders',
                    showArrowRight: true,
                    onClick: () => null,
                  ),
                  ProfileItem(
                    icon: Icons.email,
                    text: 'Invite friends',
                    showArrowRight: true,
                    onClick: () => null,
                  ),
                  ProfileItem(
                    icon: Icons.email,
                    text: 'My saved products',
                    showArrowRight: true,
                    onClick: () => Get.to(() => HowToGetCoins()),
                  ),
                  ProfileItem(
                    icon: Icons.phone,
                    text: 'Rate our App',
                    showArrowRight: true,
                    onClick: () => null,
                  ),
                  ProfileItem(
                    icon: Icons.add_business,
                    text: 'Make a suggestion',
                    showBottomBorder: false,
                    onClick: () => null,
                  ),
                  ProfileItem(
                    icon: Icons.add_business,
                    text: 'Privacy Policy',
                    showBottomBorder: false,
                    onClick: () => null,
                  ),
                  ProfileItem(
                    icon: Icons.add_business,
                    text: 'Frequently asked questions',
                    showBottomBorder: false,
                    onClick: () => null,
                  ),
                  ProfileItem(
                    icon: Icons.add_business,
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
