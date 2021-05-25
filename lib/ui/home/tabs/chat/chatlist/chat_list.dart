import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swapxchange/ui/components/dashboard_custom_appbar.dart';
import 'package:swapxchange/ui/home/tabs/chat/chatlist/chat_list_item.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';

class ChatList extends StatelessWidget {
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
