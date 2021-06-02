import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swapxchange/models/app_user.dart';
import 'package:swapxchange/models/chat_message.dart';
import 'package:swapxchange/repository/chat_methods.dart';
import 'package:swapxchange/ui/home/tabs/chat/chatdetail/sections/chat_message_item.dart';

class ChatMessageList extends StatelessWidget {
  final AppUser currentUser;
  final AppUser receiverUser;

  const ChatMessageList({Key? key, required this.currentUser, required this.receiverUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: ChatMethods.fetchChats1(user1: currentUser.userId!, user2: receiverUser.userId!),
      builder: (context, snapshot1) {
        return StreamBuilder<QuerySnapshot>(
          stream: ChatMethods.fetchChats2(user1: currentUser.userId!, user2: receiverUser.userId!),
          builder: (context, snapshot2) {
            if (!snapshot1.hasData || !snapshot2.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            final data1 = snapshot1.data!.docs;
            final data2 = snapshot2.data!.docs;
            if (data1.isEmpty && data2.isEmpty) {
              return Center(
                child: Text("You have not started any chat with this user."),
              );
            }

            List<ChatMessage> chatMessages = [];
            for (var message in data1.reversed) {
              ChatMessage msg = ChatMessage.fromMap(message.data());
              chatMessages.add(msg);
            }
            for (var message in data2.reversed) {
              ChatMessage msg = ChatMessage.fromMap(message.data());
              chatMessages.add(msg);
            }
            chatMessages.sort((a, b) => b.timestamp!.compareTo(a.timestamp!)); //desc

            return ListView.builder(
              padding: EdgeInsets.all(8),
              reverse: true,
              itemCount: chatMessages.length,
              itemBuilder: (context, index) {
                return ChatMessageItem(chatMessage: chatMessages[index]);
              },
            );
          },
        );
      },
    );
  }
}
