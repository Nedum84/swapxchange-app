import 'package:flutter/material.dart';
import 'package:swapxchange/ui/components/custom_keep_alive_page.dart';
import 'package:swapxchange/ui/home/tabs/chat/chat_list.dart';
import 'package:swapxchange/ui/home/tabs/home/home.dart';
import 'package:swapxchange/ui/home/tabs/profile/profile.dart';
import 'package:swapxchange/ui/home/tabs/saved/saved_product.dart';

class Dashboard2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: new Scaffold(
        body: new NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                title: Text("Application"),
                floating: true,
                pinned: true,
                snap: true,
                bottom: new TabBar(
                  tabs: <Tab>[
                    new Tab(text: "T"),
                    new Tab(text: "B"),
                    new Tab(text: "C"),
                    new Tab(text: "D"),
                  ], // <-- total of 2 tabs
                ),
              ),
            ];
          },
          body: new TabBarView(
            // controller: controller,
            children: <Widget>[
              CustomKeepAlivePage(child: Home()),
              CustomKeepAlivePage(child: ChatList()),
              CustomKeepAlivePage(child: SavedProduct()),
              CustomKeepAlivePage(child: Profile()),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
