import 'package:async/async.dart' show StreamGroup;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:swapxchange/repository/chat_methods.dart';
import 'package:swapxchange/ui/components/dashboard_custom_appbar.dart';
import 'package:swapxchange/ui/home/tabs/chat/chatlist/chat_list_item.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';

class ChatList extends StatelessWidget {
  final Stream<QuerySnapshot> user = ChatMethods.fetchChats1(user1: 1, user2: 2);

  final Stream<QuerySnapshot> cards = ChatMethods.fetchChats1(user1: 1, user2: 2);

  _lkk() async {
    List<Stream<QuerySnapshot>> streams = [];
    streams.add(user);
    streams.add(cards);
    Stream<QuerySnapshot> results = StreamGroup.merge(streams);
    await for (var res in results) {
      res.docs.forEach((docResults) {
        print(docResults.data);
      });
    }
  }

  _hhh() {
    CombineLatestStream.list([user, cards]).listen((data) {
      var one = data.elementAt(0);
      var ytwo = data.elementAt(1);
      var three = data.elementAt(2);
    });
  }

  Widget ioi() {
    final combinedStrems = Rx.combineLatest2(user, cards, (a, b) => a != null || b != null);

    return StreamBuilder(
        // stream: CombineLatestStream.list([
        //   user,
        //   cards,
        // ]),
        stream: combinedStrems,
        builder: (context, snapshot) {
          // final data0 = snapshot.data![0];
          // final data1 = snapshot.data[1];

          return Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            DashboardCustomAppbar(
              title: 'Chats',
              actionBtn: IconButton(
                constraints: BoxConstraints(),
                padding: EdgeInsets.all(0),
                icon: Icon(
                  Icons.phone,
                  color: KColors.TEXT_COLOR_DARK,
                ),
                onPressed: () => null,
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(Constants.PADDING),
                itemCount: 50,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return ChatListItem();
                },
                separatorBuilder: (BuildContext context, int index) => SizedBox(height: Constants.PADDING),
              ),
            )
          ],
        ),
      ),
    );
  }
}
