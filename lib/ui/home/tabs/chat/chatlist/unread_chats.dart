import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/repository/repo_chats.dart';
import 'package:swapxchange/ui/home/tabs/home/home_app_bar.dart';
import 'package:swapxchange/utils/colors.dart';

class UnreadChats extends StatelessWidget {
  final int secondUserId;
  final int myId;

  const UnreadChats({Key? key, required this.secondUserId, required this.myId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 3,
      right: 3,
      child: StreamBuilder<QuerySnapshot>(
          stream: RepoChats.getUnreadMessages(secondUserId: secondUserId, myId: myId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            final data = snapshot.data!.docs;
            if (data.isEmpty || data.length == 0) {
              return Container();
            }

            return CustomBadge(
              text: '${data.length}',
              bgColor: KColors.RED,
              py: 2,
            );
          }),
    );
  }
}

class UnreadChatsDot extends StatelessWidget {
  final int myId = UserController.to.user!.userId!;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 2,
      child: StreamBuilder<QuerySnapshot>(
          stream: RepoChats.getAllUnreadMessages(myId: myId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                height: 0,
                width: 0,
              );
            }
            final data = snapshot.data!.docs;
            if (data.isEmpty || data.length == 0) {
              return Container(
                height: 0,
                width: 0,
              );
            }

            return Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: KColors.RED,
              ),
            );
          }),
    );
  }
}
