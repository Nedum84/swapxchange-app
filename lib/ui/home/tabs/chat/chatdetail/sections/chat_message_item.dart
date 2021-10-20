import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/models/app_user.dart';
import 'package:swapxchange/models/chat_message.dart';
import 'package:swapxchange/models/product_image.dart';
import 'package:swapxchange/ui/home/tabs/chat/chatdetail/sections/chat_swap_suggestion.dart';
import 'package:swapxchange/ui/widgets/cached_image.dart';
import 'package:swapxchange/ui/widgets/view_image.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/helpers.dart';
import 'package:swapxchange/utils/styles.dart';

class ChatMessageItem extends StatelessWidget {
  final ChatMessage chatMessage;

  const ChatMessageItem({Key? key, required this.chatMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      child: Container(
        child: chatMessage.type == ChatMessageType.PRODUCT_CHAT
            ? productWidget(
                chatMessage,
              )
            : chatMessage.type == ChatMessageType.MISSED_CALL
                ? missedCallWidget(
                    chatMessage,
                  )
                : chatMessage.type == ChatMessageType.CLOSE_DEAL
                    ? closeDealWidget(
                        chatMessage,
                      )
                    : messageLayout(
                        chatMessage,
                      ),
      ),
    );
  }

  Widget productWidget(ChatMessage chatMessage) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            'Swap Suggestion',
            style: StyleNormal,
          ),
          SizedBox(height: 8),
          ChatSwapSuggestion(
            chatMsg: chatMessage.message!,
          ),
        ],
      ),
    );
  }

  Widget missedCallWidget(ChatMessage chatMessage) {
    AppUser currentUser = UserController.to.user!;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 32),
      decoration: BoxDecoration(
        color: Color(0xff273C52).withOpacity(.15),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        chatMessage.senderId == currentUser.userId ? 'This user missed your call • ${Helpers.formatDateInt(chatMessage.timestamp!)}' : 'You missed a call from this user • ${Helpers.formatDateInt(chatMessage.timestamp!)}',
        textAlign: TextAlign.center,
        style: StyleNormal.copyWith(fontSize: 10, color: KColors.TEXT_COLOR_DARK),
      ),
    );
  }

  Widget closeDealWidget(ChatMessage chatMessage) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 32),
      decoration: BoxDecoration(
        color: Color(0xff273C52).withOpacity(.15),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        '${chatMessage.message} • ${Helpers.formatDateInt(chatMessage.timestamp!)}',
        textAlign: TextAlign.center,
        style: StyleNormal.copyWith(fontSize: 10, color: KColors.TEXT_COLOR_DARK),
      ),
    );
  }

  getMessage(ChatMessage message) {
    if (message.type == ChatMessageType.TEXT)
      return Text(
        message.message!,
        style: StyleNormal.copyWith(
          color: KColors.TEXT_COLOR_DARK,
        ),
      );
    else if (message.photoUrl != null && message.type == ChatMessageType.IMAGE)
      return CachedImage(
        message.photoUrl!,
        height: 200,
        width: double.infinity,
        radius: 10,
        onClick: () => Get.to(
          () => ViewImage(
            curStep: 0,
            imageProducts: [
              ProductImage(imagePath: message.photoUrl, productId: null, imageId: null, idx: 0),
            ],
          ),
        ),
      );
    else {
      return Container();
    }
  }

  Widget messageLayout(ChatMessage message) {
    AppUser currentUser = UserController.to.user!;

    Radius messageRadius = Radius.circular(10);
    Radius zeroRadius = Radius.circular(0);
    bool isMine = message.senderId == currentUser.userId;

    return Container(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(10),
        constraints: BoxConstraints(maxWidth: Get.mediaQuery.size.width * 0.7),
        decoration: BoxDecoration(
          color: isMine ? Color.fromRGBO(80, 179, 113, .15) : Colors.white70.withOpacity(.4),
          border: Border.all(color: Colors.blueGrey.withOpacity(.2), width: 1),
          borderRadius: BorderRadius.only(
            topLeft: messageRadius,
            topRight: messageRadius,
            bottomLeft: isMine ? messageRadius : zeroRadius, //sender
            bottomRight: isMine ? zeroRadius : messageRadius, //receiver
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            getMessage(message),
            SizedBox(height: 2),
            Text(
              Helpers.formatDateInt(message.timestamp!),
              style: StyleNormal.copyWith(fontSize: 10, color: Colors.black38),
            )
          ],
        ),
      ),
    );
  }
}
