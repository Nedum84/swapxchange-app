import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/product_controller.dart';
import 'package:swapxchange/controllers/product_search_controller.dart';
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/models/notification_model.dart';
import 'package:swapxchange/repository/notification_repo.dart';
import 'package:swapxchange/ui/home/notification/notification_list.dart';
import 'package:swapxchange/ui/home/search/product_search.dart';
import 'package:swapxchange/ui/home/tabs/profile/sections/settings/change_location.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

class HomeAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (pController) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: AnimatedOpacity(
                opacity: pController.pageTitle.isEmpty ? 0 : 1,
                duration: Duration(seconds: 1),
                child: Text(
                  "${pController.pageTitle}",
                  style: H1Style,
                ),
              ),
            ),
            MenuIcon(
              icon: Icons.search,
              onClick: () {
                // Get.offAll(() => SplashScreen());
                // return;
                ProductSearchController.to.fetchProducts();
                Get.to(() => ProductSearch());
              },
            ),
            MenuBadge(
              icon: Icons.notifications_none,
              onClick: () => Get.to(() => NotificationList()),
            ),
          ],
        ),
      );
    });
  }
}

class UserAddress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => Get.to(() => ChangeLocation()),
        child: Row(
          children: [
            GetBuilder<UserController>(builder: (userController) {
              return Expanded(
                child: Text(
                  userController.user!.address ?? "",
                  style: StyleNormal,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }),
            Icon(
              Icons.keyboard_arrow_down,
              color: KColors.TEXT_COLOR,
            ),
          ],
        ),
      ),
    );
  }
}

class MenuIcon extends StatelessWidget {
  final IconData icon;
  final Function() onClick;

  const MenuIcon({Key? key, required this.icon, required this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
        icon: Icon(
          icon,
          // color: Color(0xff707070),
          color: KColors.TEXT_COLOR_DARK,
          size: 28,
        ),
        onPressed: onClick,
      ),
    );
  }
}

class MenuBadge extends StatelessWidget {
  final IconData icon;
  final Function() onClick;

  const MenuBadge({Key? key, required this.icon, required this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              icon,
              // color: Color(0xff707070),
              color: KColors.TEXT_COLOR_DARK,
              size: 28,
            ),
            Positioned(
              bottom: -8,
              left: -4,
              child: StreamBuilder<QuerySnapshot>(
                stream: NotificationRepo.getMyNotifications(myId: UserController.to.user!.userId!),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  final data = snapshot.data!.docs;
                  var items = (data).map((data) => NotificationModel.fromMap(data.data() as Map<String, dynamic>)).toList();
                  if (items.length == 0) {
                    return Container();
                  }
                  final unReads = items.where((e) => e.isRead == false).toList();
                  if (unReads.length == 0) {
                    return Container();
                  }

                  return CustomBadge(text: '${unReads.length}');
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomBadge extends StatelessWidget {
  final String? text;
  final bool isRound;
  final Color? bgColor;
  final double? py;

  const CustomBadge({Key? key, this.text, this.isRound = false, this.bgColor, this.py}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: py ?? 4, horizontal: isRound ? 4 : 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: bgColor ?? KColors.PRIMARY,
      ),
      child: Text(
        text ?? '0',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
