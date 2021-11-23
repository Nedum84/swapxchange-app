import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/models/app_user.dart';
import 'package:swapxchange/models/chat_message.dart';
import 'package:swapxchange/repository/repo_chats.dart';
import 'package:swapxchange/ui/home/tabs/chat/chatlist/chat_list_item.dart';
import 'package:swapxchange/ui/widgets/dashboard_custom_appbar.dart';
import 'package:swapxchange/ui/widgets/loading_progressbar.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/styles.dart';

class ChatList extends StatelessWidget {
  AppUser? user = UserController.to.user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            DashboardCustomAppbar(
              title: 'Chats',
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: RepoChats.fetchChatList1(userId: user!.userId!),
                builder: (context, snapshot1) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: RepoChats.fetchChatList2(userId: user!.userId!),
                    builder: (context, snapshot2) {
                      if (!snapshot1.hasData || !snapshot2.hasData) {
                        return Center(child: LoadingProgressMultiColor());
                      }
                      final data1 = snapshot1.data!.docs;
                      final data2 = snapshot2.data!.docs;
                      if (data1.isEmpty && data2.isEmpty) {
                        return Center(
                          child: Text(
                            "You've got no conversation yet",
                            style: StyleNormal.copyWith(
                              color: KColors.TEXT_COLOR_DARK,
                            ),
                          ),
                        );
                      }

                      List<ChatMessage> chatMessages = [];
                      for (var message in data1.reversed) {
                        ChatMessage msg = ChatMessage.fromMap(message.data() as Map<String, dynamic>);
                        chatMessages.add(msg);
                      }
                      for (var message in data2.reversed) {
                        ChatMessage msg = ChatMessage.fromMap(message.data() as Map<String, dynamic>);
                        chatMessages.add(msg);
                      }
                      chatMessages.sort((a, b) => b.timestamp!.compareTo(a.timestamp!)); //desc

                      chatMessages.forEach((element) {
                        if (element.senderId == user!.userId) {
                          element.secondUserId = element.receiverId!;
                        } else {
                          element.secondUserId = element.senderId!;
                        }
                      });

                      //Distinct by the user ID
                      final list = chatMessages.map((e) => e.secondUserId).toSet();
                      chatMessages.retainWhere((element) => list.remove(element.secondUserId));

                      return ListView.separated(
                        padding: EdgeInsets.all(Constants.PADDING),
                        itemCount: chatMessages.length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatListItem(chatMessage: chatMessages[index]);
                        },
                        separatorBuilder: (BuildContext context, int index) => SizedBox(height: Constants.PADDING / 2),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
