import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
