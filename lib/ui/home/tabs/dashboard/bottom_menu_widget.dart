import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/add_product_controller.dart';
import 'package:swapxchange/controllers/bottom_menu_controller.dart';
import 'package:swapxchange/enum/bottom_menu_item.dart';
import 'package:swapxchange/ui/home/product/addproduct/add_product.dart';
import 'package:swapxchange/utils/colors.dart';

class BottomMenuWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final BottomMenuItem bottomMenuItem;

  BottomMenuWidget({
    required this.title,
    required this.icon,
    required this.bottomMenuItem,
  });

  @override
  Widget build(BuildContext context) {
    // return Container();
    return GetBuilder<BottomMenuController>(
      init: BottomMenuController(),
      builder: (bottomMenuProvider) {
        return InkWell(
          onTap: () => bottomMenuProvider.onChangeMenu(bottomMenuItem),
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: (bottomMenuProvider.bottomMenuItem == bottomMenuItem) ? KColors.TEXT_COLOR_MEDIUM : Colors.black12,
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: (bottomMenuProvider.bottomMenuItem == bottomMenuItem) ? KColors.TEXT_COLOR_MEDIUM : Colors.black12,
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
                  Icons.add,
                  color: Colors.black12,
                ),
                Text(
                  'Add',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black12,
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
