import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/ui/components/dashboard_custom_appbar.dart';
import 'package:swapxchange/ui/home/tabs/profile/sections/settings/settings.dart';
import 'package:swapxchange/ui/home/tabs/profile/sections/wallet/how_to_get_coins.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/styles.dart';

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
              actionBtn: IconButton(
                constraints: BoxConstraints(),
                padding: EdgeInsets.all(0),
                icon: Icon(
                  Icons.settings,
                  color: KColors.TEXT_COLOR_DARK,
                ),
                onPressed: () => Get.to(() => Settings(), transition: Transition.rightToLeftWithFade),
              ),
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
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          boxShadow: [Constants.SHADOW],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            'images/swapx.jpeg',
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nelly Eduodo',
                              style: H2Style,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Color(0xffCD4F4E).withOpacity(.8),
                                  size: 18,
                                ),
                                Text(
                                  'Ogui road Enugu',
                                  style: StyleCategorySubTitle,
                                ),
                              ],
                            ),
                          ],
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
                    onClick: () => Get.to(
                      () => Settings(),
                      transition: Transition.rightToLeftWithFade,
                    ),
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
                    onClick: () => Get.to(
                      () => HowToGetCoins(),
                      transition: Transition.rightToLeftWithFade,
                    ),
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
          Text(
            '500 coins',
            style: StyleNormal,
          ),
          SizedBox(width: 8),
          Container(
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
        ],
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool showBottomBorder;
  final bool showArrowRight;
  final Function() onClick;

  const ProfileItem({Key? key, required this.text, required this.icon, this.showBottomBorder = false, this.showArrowRight = true, required this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: KColors.TEXT_COLOR_LIGHT2.withOpacity(.12)),
            bottom: BorderSide(color: showBottomBorder ? KColors.TEXT_COLOR_LIGHT2.withOpacity(.12) : Colors.transparent),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: KColors.TEXT_COLOR.withOpacity(1),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: StyleNormal.copyWith(color: KColors.TEXT_COLOR_DARK),
              ),
            ),
            SizedBox(width: 4),
            !showArrowRight
                ? Container()
                : CircleAvatar(
                    backgroundColor: Color(0xffE4E5E8),
                    radius: 10,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: KColors.TEXT_COLOR,
                      size: 10,
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
