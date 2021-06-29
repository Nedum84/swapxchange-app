import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/add_product_controller.dart';
import 'package:swapxchange/controllers/bottom_menu_controller.dart';
import 'package:swapxchange/enum/bottom_menu_item.dart';
import 'package:swapxchange/ui/home/product/addproduct/add_product.dart';
import 'package:swapxchange/ui/home/tabs/chat/chatlist/unread_chats.dart';
import 'package:swapxchange/utils/colors.dart';

class BottomMenuWidget extends StatelessWidget {
  final String title;
  final BottomMenuItem bottomMenuItem;

  BottomMenuWidget({
    required this.title,
    required this.bottomMenuItem,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomMenuController>(
      init: BottomMenuController(),
      builder: (bottomMenuProvider) {
        final isCurrent = bottomMenuProvider.bottomMenuItem == bottomMenuItem;
        return InkWell(
          onTap: () => bottomMenuProvider.onChangeMenu(bottomMenuItem),
          child: Container(
            padding: EdgeInsets.all(8),
            child: Stack(
              //Stack to allow badge dot display
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      bottomMenuProvider.bottomIcon(bottomMenuItem),
                      color: isCurrent ? KColors.TEXT_COLOR_MEDIUM : KColors.TEXT_COLOR_MEDIUM.withOpacity(.4),
                      size: isCurrent ? 22 : 18,
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 10,
                        color: isCurrent ? KColors.TEXT_COLOR_MEDIUM : KColors.TEXT_COLOR_MEDIUM.withOpacity(.4),
                      ),
                    )
                  ],
                ),
                if (bottomMenuItem == BottomMenuItem.CHAT) UnreadChatsDot(), //Dot Badge
              ],
            ),
          ),
        );
      },
    );
  }
}

class AddMenuWidget extends StatelessWidget {
  final addCont = AddProductController.to;

  _gotoAddProduct() {
    if (addCont.product == null) {
      addCont.setEditing(false);
      addCont.create();
    }
    Get.to(() => AddProduct());
  }

  @override
  Widget build(BuildContext context) {
    // return Container();
    return GetBuilder<BottomMenuController>(
      init: BottomMenuController(),
      builder: (bottomMenuProvider) {
        return InkWell(
          onTap: _gotoAddProduct,
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  FontAwesomeIcons.plusSquare,
                  color: KColors.TEXT_COLOR_MEDIUM.withOpacity(.4),
                  size: 18,
                ),
                Text(
                  'Add',
                  style: TextStyle(
                    fontSize: 10,
                    color: KColors.TEXT_COLOR_MEDIUM.withOpacity(.4),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
