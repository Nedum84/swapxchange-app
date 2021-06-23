import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/repository/auth_repo.dart';
import 'package:swapxchange/ui/home/tabs/profile/sections/privacy/privacy.dart';
import 'package:swapxchange/ui/home/tabs/profile/sections/settings/change_location.dart';
import 'package:swapxchange/ui/home/tabs/profile/sections/settings/editprofile.dart';
import 'package:swapxchange/ui/home/tabs/profile/sections/settings/modals/notification_modal.dart';
import 'package:swapxchange/ui/home/tabs/profile/sections/settings/terms.dart';
import 'package:swapxchange/ui/widgets/cached_image.dart';
import 'package:swapxchange/utils/alert_utils.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

class Settings extends StatelessWidget {
  var top = 0.0;
  _logOut() {
    AlertUtils.confirm(
      'Your products & settings are saved. Proceed to logout?',
      title: 'Logout!',
      positiveBtnText: 'YES, LOG ME OUT',
      okCallBack: () async {
        AuthRepo().signOut();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      backgroundColor: KColors.WHITE_GREY,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            shadowColor: Colors.transparent,
            backgroundColor: KColors.WHITE_GREY2,
            pinned: true,
            expandedHeight: 200,
            stretch: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_sharp),
              onPressed: () => Navigator.pop(context),
              color: KColors.TEXT_COLOR_DARK,
            ),
            flexibleSpace: GetBuilder<UserController>(
              builder: (userController) {
                return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                  top = constraints.biggest.height;
                  return FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    centerTitle: false,
                    title: Text(
                      "User Settings",
                      style: H1Style.copyWith(color: top <= 120 ? KColors.TEXT_COLOR_DARK : Colors.white70),
                    ),
                    background: userController.user!.profilePhoto == null || userController.user!.profilePhoto!.isEmpty
                        ? Container()
                        : CachedImage(
                            userController.user!.profilePhoto,
                            fit: BoxFit.cover,
                          ),
                  );
                });
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                CustomTile(
                  title: 'Edit Profile',
                  onClick: () => Get.to(
                    () => EditProfile(),
                  ),
                ),
                CustomTile(
                  title: 'Change Location',
                  onClick: () => Get.to(
                    () => ChangeLocation(),
                  ),
                ),
                CustomTile(
                  title: 'Notification',
                  onClick: () => Get.bottomSheet(NotificationModal()),
                  trailing: Container(
                    width: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GetBuilder<UserController>(builder: (userController) {
                          final uN = userController.user!.notification!;
                          final isOn = uN.general == 1 || uN.chat == 1 || uN.product == 1 || uN.call == 1;
                          return Text(
                            isOn ? 'On' : 'Off',
                            style: StyleNormal.copyWith(color: isOn ? KColors.PRIMARY : KColors.RED),
                          );
                        }),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: KColors.TEXT_COLOR.withOpacity(.3),
                        )
                      ],
                    ),
                  ),
                ),
                CustomTile(
                  title: 'Base Currency',
                  onClick: () => null,
                  trailing: Container(
                    width: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${UserController.to.user!.baseCurrency}',
                          style: StyleNormal.copyWith(color: KColors.PRIMARY),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: KColors.TEXT_COLOR.withOpacity(.3),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32),
                CustomTile(
                  title: 'Terms & conditions',
                  onClick: () => Get.to(() => TermsAndConditions()),
                ),
                CustomTile(
                  title: 'Privacy policy',
                  onClick: () => Get.to(() => Privacy()),
                ),
                SizedBox(height: 32),
                Container(
                  color: Colors.white,
                  child: ListTile(
                    onTap: _logOut,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    title: Text(
                      'Log out',
                      textAlign: TextAlign.center,
                      style: StyleNormal.copyWith(
                        color: KColors.RED,
                      ),
                    ),
                  ),
                ),
                SwapVersion()
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTile extends StatelessWidget {
  final String title;
  final Function() onClick;
  final Widget? trailing;

  const CustomTile({Key? key, required this.title, required this.onClick, this.trailing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 1),
      child: ListTile(
        onTap: onClick,
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        title: Text(
          title,
          style: StyleNormal.copyWith(fontSize: 16),
        ),
        trailing: trailing ??
            Icon(
              Icons.arrow_forward_ios,
              color: KColors.TEXT_COLOR.withOpacity(.3),
            ),
      ),
    );
  }
}

class SwapVersion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Image.asset(
            'images/logo1.png',
            width: 240,
            height: 240,
          ),
          Container(
            transform: Matrix4.translationValues(0.0, -80.0, 0.0),
            child: Column(
              children: [
                Text(
                  'Version 1.2.212',
                  style: StyleNormal.copyWith(
                    color: KColors.TEXT_COLOR_LIGHT,
                  ),
                ),
                Text(
                  'Website:  www.swapxchange.shop',
                  style: StyleNormal.copyWith(
                    color: KColors.TEXT_COLOR_LIGHT,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
