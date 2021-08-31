import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/bottom_menu_controller.dart';
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/enum/bottom_menu_item.dart';
import 'package:swapxchange/enum/online_status.dart';
import 'package:swapxchange/models/app_user.dart';
import 'package:swapxchange/repository/auth_repo.dart';
import 'package:swapxchange/ui/home/callscreens/pickup_layout.dart';
import 'package:swapxchange/ui/home/tabs/chat/chatlist/chat_list.dart';
import 'package:swapxchange/ui/home/tabs/dashboard/register_notification.dart';
import 'package:swapxchange/ui/home/tabs/home/home.dart';
import 'package:swapxchange/ui/home/tabs/profile/profile.dart';
import 'package:swapxchange/ui/home/tabs/saved/saved_product.dart';
import 'package:swapxchange/ui/widgets/custom_keep_alive_page.dart';

import 'bottom_menu_widget.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with WidgetsBindingObserver {
  AuthRepo _authMethods = AuthRepo();

  @override
  void initState() {
    super.initState();
    _init();
    //Register notification
    updateNotificationToken();
  }

  _init() {
    AppUser currentUser = UserController.to.user!;
    SchedulerBinding.instance!.addPostFrameCallback((_) async {
      _authMethods.setOnlineStatus(uid: currentUser.uid!, userState: OnlineStatus.ONLINE);
    });

    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    AppUser currentUser = UserController.to.user!;

    switch (state) {
      case AppLifecycleState.resumed:
        _authMethods.setOnlineStatus(uid: currentUser.uid!, userState: OnlineStatus.ONLINE);
        print("resume state");
        break;
      case AppLifecycleState.inactive:
        _authMethods.setOnlineStatus(uid: currentUser.uid!, userState: OnlineStatus.OFFLINE);
        print("inactive state");
        break;
      case AppLifecycleState.paused:
        _authMethods.setOnlineStatus(uid: currentUser.uid!, userState: OnlineStatus.AWAY);
        print("paused state");
        break;
      case AppLifecycleState.detached:
        _authMethods.setOnlineStatus(uid: currentUser.uid!, userState: OnlineStatus.OFFLINE);
        print("detached state");
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  _backPressed() {
    final con = Get.find<BottomMenuController>();
    if (con.bottomMenuItem != BottomMenuItem.HOME) {
      con.onChangeMenu(BottomMenuItem.HOME);
    } else {
      if (!Platform.isIOS) {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get.put(BottomMenuController());
    return WillPopScope(
      onWillPop: () => Future.value(_backPressed()),
      child: PickupLayout(
        scaffold: Scaffold(
          body: Container(
            padding: EdgeInsets.only(top: context.mediaQueryPadding.top),
            child: PageView(
              controller: Get.find<BottomMenuController>().pageViewController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                CustomKeepAlivePage(child: Home()),
                CustomKeepAlivePage(child: ChatList()),
                CustomKeepAlivePage(child: SavedProduct()),
                CustomKeepAlivePage(child: Profile()),
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            child: new Row(
              // mainAxisSize: MainAxisSize.max,
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: BottomMenuWidget(
                    title: 'Latest',
                    bottomMenuItem: BottomMenuItem.HOME,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: BottomMenuWidget(
                    title: 'Chat',
                    bottomMenuItem: BottomMenuItem.CHAT,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: AddMenuWidget(),
                ),
                Expanded(
                  flex: 1,
                  child: BottomMenuWidget(
                    title: 'Saved',
                    bottomMenuItem: BottomMenuItem.SAVED,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: BottomMenuWidget(
                    title: 'Account',
                    bottomMenuItem: BottomMenuItem.PROFILE,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
