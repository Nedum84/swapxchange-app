import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:swapxchange/enum/bottom_menu_item.dart';

class BottomMenuController extends GetxController {
  PageController pageViewController = PageController(initialPage: 0);
  BottomMenuItem _bottomMenuItem = BottomMenuItem.HOME;

  BottomMenuItem get bottomMenuItem => _bottomMenuItem;

  void onChangeMenu(BottomMenuItem item) {
    _bottomMenuItem = item;
    update();
    pageViewController.animateToPage(menuIndex(), duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  int menuIndex() {
    switch (bottomMenuItem) {
      case BottomMenuItem.HOME:
        return 0;
      case BottomMenuItem.CHAT:
        return 1;
      case BottomMenuItem.SAVED:
        return 2;
      case BottomMenuItem.PROFILE:
        return 3;
      default:
        return 0;
    }
  }

  IconData bottomIcon(BottomMenuItem currentItem) {
    if (currentItem == BottomMenuItem.HOME) {
      if (currentItem == _bottomMenuItem) {
        return FontAwesomeIcons.fire;
      } else {
        return FontAwesomeIcons.fire;
      }
    } else if (currentItem == BottomMenuItem.CHAT) {
      if (currentItem == _bottomMenuItem) {
        return FontAwesomeIcons.solidCommentAlt;
      } else {
        return FontAwesomeIcons.commentAlt;
      }
    } else if (currentItem == BottomMenuItem.SAVED) {
      if (currentItem == _bottomMenuItem) {
        return FontAwesomeIcons.solidHeart;
      } else {
        return FontAwesomeIcons.heart;
      }
    } else if (currentItem == BottomMenuItem.PROFILE) {
      if (currentItem == _bottomMenuItem) {
        return FontAwesomeIcons.solidUser;
      } else {
        return FontAwesomeIcons.user;
      }
    } else {
      return FontAwesomeIcons.plusSquare;
    }
  }
}
