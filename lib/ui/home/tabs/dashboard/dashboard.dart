import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:swapxchange/enum/bottom_menu_item.dart';

import 'bottom_menu_widget.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with WidgetsBindingObserver {
  PageController pageViewController = PageController(initialPage: 0);

  Socket? socket;
  @override
  void initState() {
    super.initState();
    _init();

    Socket.connect("localhost", 8080).then((Socket sock) {
      socket = sock;
      socket?.listen(dataHandler,
          onError: errorHandler, onDone: doneHandler, cancelOnError: false);
    }).catchError((e) {
      print("Unable to connect: $e");
    });
    //Connect standard in to the socket
    stdin.listen((data) {
      socket?.write(new String.fromCharCodes(data).trim() + '\n');
      // print(new String.fromCharCodes(data).trim() + '\n');
    });
  }

  void dataHandler(data) {
    print(new String.fromCharCodes(data).trim());
  }

  void errorHandler(error, StackTrace trace) {
    print(error);
  }

  void doneHandler() {
    socket?.close();
    socket?.destroy();
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
          child: InkWell(
            onTap: () => socket?.write('{"ewew": "ewe", "dsdsd": "sdsdsd"}'),
            child: Text("Hey"),
          )
          //   PageView(
          //     controller: pageViewController,
          //     physics: NeverScrollableScrollPhysics(),
          //     children: [
          //       CustomKeepAlivePage(child: Home()),
          //       CustomKeepAlivePage(child: ChatList()),
          //       CustomKeepAlivePage(child: SavedProduct()),
          //       CustomKeepAlivePage(child: Profile()),
          //     ],
          //   ),
          ),
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            BottomMenuWidget(
              pageViewController: pageViewController,
              title: 'Home',
              icon: Icons.dashboard,
              bottomMenuItem: BottomMenuItem.HOME,
            ),
            BottomMenuWidget(
              pageViewController: pageViewController,
              title: 'Chat',
              icon: Icons.offline_share,
              bottomMenuItem: BottomMenuItem.CHAT,
            ),
            BottomMenuWidget(
              pageViewController: pageViewController,
              title: 'Add',
              icon: Icons.add,
              bottomMenuItem: BottomMenuItem.ADD,
            ),
            BottomMenuWidget(
              pageViewController: pageViewController,
              title: 'Saved',
              icon: Icons.chat_outlined,
              bottomMenuItem: BottomMenuItem.SAVED,
            ),
            BottomMenuWidget(
              pageViewController: pageViewController,
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
