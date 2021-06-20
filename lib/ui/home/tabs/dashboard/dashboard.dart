import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/bottom_menu_controller.dart';
import 'package:swapxchange/enum/bottom_menu_item.dart';
import 'package:swapxchange/ui/components/custom_keep_alive_page.dart';
import 'package:swapxchange/ui/home/tabs/chat/chatlist/chat_list.dart';
import 'package:swapxchange/ui/home/tabs/home/home.dart';
import 'package:swapxchange/ui/home/tabs/profile/profile.dart';
import 'package:swapxchange/ui/home/tabs/saved/saved_product.dart';

import 'bottom_menu_widget.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {}

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            BottomMenuWidget(
              title: 'Home',
              icon: Icons.dashboard,
              bottomMenuItem: BottomMenuItem.HOME,
            ),
            BottomMenuWidget(
              title: 'Chat',
              icon: Icons.offline_share,
              bottomMenuItem: BottomMenuItem.CHAT,
            ),
            AddMenuWidget(),
            BottomMenuWidget(
              title: 'Saved',
              icon: Icons.chat_outlined,
              bottomMenuItem: BottomMenuItem.SAVED,
            ),
            BottomMenuWidget(
              title: 'Profile',
              icon: Icons.favorite_rounded,
              bottomMenuItem: BottomMenuItem.PROFILE,
            ),
          ],
        ),
      ),
    );
  }
}
