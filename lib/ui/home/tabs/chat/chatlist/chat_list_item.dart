import 'package:flutter/material.dart';
import 'package:swapxchange/models/chat_message.dart';
import 'package:swapxchange/ui/home/tabs/home/home_app_bar.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/styles.dart';

class ChatListItem extends StatelessWidget {
  final ChatMessage chatMessage;

  const ChatListItem({Key? key, required this.chatMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => null,
      // splashColor: KColors.SECONDARY.withOpacity(.2),
      child: Container(
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Stack(
                children: [
                  Image.asset(
                    'images/swapx.jpeg',
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: CustomBadge(
                      text: '32',
                      bgColor: KColors.RED,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(Constants.PADDING / 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'images/swapx.jpeg',
                            width: 24,
                            height: 24,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Emeka Paul',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: StyleNormal.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    Text(
                      "${chatMessage.message}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: StyleNormal.copyWith(
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Text(
                  'Tue,5:12AM',
                  style: StyleNormal.copyWith(
                    color: KColors.TEXT_COLOR_LIGHT,
                    fontSize: 10,
                  ),
                ),
                SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.asset(
                    'images/swapx.jpeg',
                    width: 55,
                    height: 55,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
