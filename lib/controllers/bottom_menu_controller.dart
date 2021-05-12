import 'package:get/get.dart';
import 'package:swapxchange/enum/bottom_menu_item.dart';

class BottomMenuController extends GetxController {
  BottomMenuItem _bottomMenuItem = BottomMenuItem.HOME;

  BottomMenuItem get bottomMenuItem => _bottomMenuItem;

  void onChangeMenu(BottomMenuItem item) {
    _bottomMenuItem = item;
    update();
  }
}
