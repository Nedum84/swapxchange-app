import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/models/app_user.dart';
import 'package:swapxchange/models/chat_message.dart';
import 'package:swapxchange/models/product_chats.dart';
import 'package:swapxchange/repository/repo_product_chats.dart';
import 'package:swapxchange/ui/home/tabs/chat/chatdetail/chat_detail.dart';
import 'package:swapxchange/ui/home/tabs/chat/chatlist/unread_chats.dart';
import 'package:swapxchange/ui/widgets/cached_image.dart';
import 'package:swapxchange/ui/widgets/question_mark.dart';
import 'package:swapxchange/utils/alert_utils.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/helpers.dart';
import 'package:swapxchange/utils/styles.dart';

class ChatListItem extends StatelessWidget {
  final ChatMessage chatMessage;

  const ChatListItem({Key? key, required this.chatMessage}) : super(key: key);

  String lastMessage(UserController userController) {
    String msg;
    if (chatMessage.type == ChatMessageType.PRODUCT_CHAT) {
      msg = 'Swap Suggestion';
    } else if (chatMessage.type == ChatMessageType.IMAGE) {
      msg = chatMessage.senderId == userController.user!.userId ? "You sent a photo" : 'User sent you photo';
    } else {
      msg = chatMessage.message!;
    }

    return msg;
  }

  Widget _sentIcon(UserController userController) {
    if (chatMessage.senderId != userController.user!.userId) {
      return Container();
    }
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          right: 6,
          child: Icon(
            Icons.check,
            color: chatMessage.isRead ? KColors.PRIMARY.withOpacity(.8) : KColors.TEXT_COLOR_DARK.withOpacity(.3),
            size: 16,
          ),
        ),
        Icon(
          Icons.check,
          color: chatMessage.isRead ? KColors.PRIMARY.withOpacity(.8) : KColors.TEXT_COLOR_DARK.withOpacity(.3),
          size: 16,
        ),
      ],
    );
  }

  _getToChat(UserController userController) async {
    final poster = await userController.getUser(userId: chatMessage.secondUserId);
    if (poster != null) {
      Get.to(() => ChatDetail(receiver: poster));
    } else {
      AlertUtils.toast('Error connecting to the server');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userController = UserController.to;

    return FutureBuilder<ProductChats?>(
        future: RepoProductChats.findRecentBwTwoUsers(secondUserId: chatMessage.secondUserId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          final pChat = snapshot.data;
          String? myProductPhoto;
          String? secondUserProductPhoto;
          if (pChat!.receiverId == userController.user!.userId) {
            if (pChat.productImages != null && pChat.productImages!.isNotEmpty) {
              myProductPhoto = pChat.productImages?.first.imagePath!;
            }
            if (pChat.productOfferImages != null && pChat.productOfferImages!.isNotEmpty) {
              secondUserProductPhoto = pChat.productOfferImages?.first.imagePath!;
            }
          } else {
            if (pChat.productOfferImages != null && pChat.productOfferImages!.isNotEmpty) {
              myProductPhoto = pChat.productOfferImages?.first.imagePath!;
            }
            if (pChat.productImages != null && pChat.productImages!.isNotEmpty) {
              secondUserProductPhoto = pChat.productImages?.first.imagePath!;
            }
          }

          return InkWell(
            onTap: () => _getToChat(userController),
            splashColor: KColors.PRIMARY.withOpacity(.1),
            child: Container(
              child: Row(
                children: [
                  Stack(
                    children: [
                      (secondUserProductPhoto == null || secondUserProductPhoto.isEmpty)
                          ? QuestionMark(
                              width: 70,
                              height: 70,
                              radius: 4,
                            )
                          : CachedImage(
                              secondUserProductPhoto,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                              radius: 4,
                            ),
                      UnreadChats(
                        secondUserId: chatMessage.secondUserId,
                        myId: userController.user!.userId!,
                      )
                    ],
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(Constants.PADDING / 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder<AppUser?>(
                              future: userController.getUser(userId: chatMessage.secondUserId),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                }

                                final user = snapshot.data;
                                return Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: CachedImage(
                                        '${user?.profilePhoto}',
                                        width: 24,
                                        height: 24,
                                        fit: BoxFit.cover,
                                        radius: 50,
                                        alt: ImagePlaceholder.User,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${user?.name}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: StyleNormal.copyWith(
                                              color: KColors.TEXT_COLOR_DARK,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          _sentIcon(userController),
                                        ],
                                      ),
                                    )
                                  ],
                                );
                              }),
                          Text(
                            lastMessage(userController),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: StyleNormal.copyWith(
                              color: KColors.TEXT_COLOR_DARK,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Swap suggestion',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: StyleNormal.copyWith(fontWeight: FontWeight.w300, fontSize: 12, color: KColors.TEXT_COLOR_LIGHT),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        Helpers.formatDateInt2(chatMessage.timestamp!),
                        style: StyleNormal.copyWith(
                          color: KColors.TEXT_COLOR_LIGHT,
                          fontSize: 10,
                        ),
                      ),
                      SizedBox(height: 4),
                      (myProductPhoto == null || myProductPhoto.isEmpty)
                          ? QuestionMark(
                              width: 55,
                              height: 55,
                              radius: 4,
                            )
                          : CachedImage(
                              myProductPhoto,
                              width: 55,
                              height: 55,
                              fit: BoxFit.cover,
                              radius: 4,
                            ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
