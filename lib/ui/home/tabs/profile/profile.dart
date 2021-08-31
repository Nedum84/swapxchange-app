import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import 'package:swapxchange/controllers/bottom_menu_controller.dart';
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/enum/bottom_menu_item.dart';
import 'package:swapxchange/ui/admin/overview/admin_overview.dart';
import 'package:swapxchange/ui/home/tabs/profile/sections/aboutus/aboutus.dart';
import 'package:swapxchange/ui/home/tabs/profile/sections/faqs/Faqs.dart';
import 'package:swapxchange/ui/home/tabs/profile/sections/feedback/give_feedback.dart';
import 'package:swapxchange/ui/home/tabs/profile/sections/myproducts/myproducts.dart';
import 'package:swapxchange/ui/home/tabs/profile/sections/privacy/privacy.dart';
import 'package:swapxchange/ui/home/tabs/profile/sections/settings/settings.dart';
import 'package:swapxchange/ui/home/tabs/profile/sections/wallet/how_to_get_coins.dart';
import 'package:swapxchange/ui/home/tabs/profile/widgets/get_coin_widget.dart';
import 'package:swapxchange/ui/home/tabs/profile/widgets/profile_list_item.dart';
import 'package:swapxchange/ui/home/tabs/profile/widgets/user_details_widget.dart';
import 'package:swapxchange/ui/widgets/dashboard_custom_appbar.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/styles.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ScrollController? controller = ScrollController();

  bool showTitle = false;

  bool handleScrollNotification(ScrollNotification notification) {
    //--> For scroll  text change
    if (controller!.position.extentBefore >= 30 && !showTitle) {
      setState(() {
        showTitle = true;
      });
    } else if (controller!.position.extentBefore < 30 && showTitle) {
      setState(() {
        showTitle = false;
      });
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          GetBuilder<UserController>(builder: (userController) {
            return DashboardCustomAppbar(
              titleWidget: AnimatedOpacity(
                opacity: !showTitle ? 0 : 1,
                duration: Duration(seconds: 1),
                child: Text(
                  showTitle ? userController.user!.name ?? "" : "",
                  style: H1Style,
                ),
              ),
              title: "",
              icon: Icons.settings,
              iconClick: () => Get.to(() => Settings()),
            );
          }),
          Expanded(
            child: NotificationListener(
              onNotification: handleScrollNotification,
              child: ListView(
                controller: controller,
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
                    icon: Icons.settings,
                    text: 'Edit profile',
                    showArrowRight: true,
                    onClick: () => Get.to(() => Settings()),
                  ),
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
                    onClick: () => Get.to(() => MyProducts()),
                  ),
                  ProfileItem(
                    icon: Icons.credit_card_rounded,
                    text: 'My saved products',
                    showArrowRight: true,
                    onClick: () => Get.find<BottomMenuController>().onChangeMenu(BottomMenuItem.SAVED),
                  ),
                  ProfileItem(
                    icon: Icons.share,
                    text: 'Invite friends',
                    showArrowRight: true,
                    onClick: () => Share.share(Constants.SHARE_CONTENT, subject: 'Share via'),
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
                    onClick: () => Get.to(() => GiveFeedback()),
                  ),
                  ProfileItem(
                    icon: Icons.policy,
                    text: 'Privacy Policy',
                    showBottomBorder: false,
                    onClick: () => Get.to(() => Privacy()),
                  ),
                  ProfileItem(
                    icon: Icons.question_answer_outlined,
                    text: 'Frequently asked questions',
                    showBottomBorder: false,
                    onClick: () => Get.to(() => Faqs()),
                  ),
                  ProfileItem(
                    icon: Icons.info_outlined,
                    text: 'About swapXchange',
                    showBottomBorder: true,
                    onClick: () => Get.to(() => AboutUs()),
                  ),
                  if (UserController.to.user!.userLevel == 2)
                    ProfileItem(
                      icon: Icons.assistant_direction,
                      text: 'Login to admin',
                      showBottomBorder: true,
                      onClick: () => Get.to(() => AdminOverview()),
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
