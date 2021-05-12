import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swapxchange/ui/components/dashboard_custom_appbar.dart';
import 'package:swapxchange/ui/home/tabs/home/home_app_bar.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/strings.dart';
import 'package:swapxchange/utils/styles.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

Future<Socket> connect() async {
  return await Socket.connect('localhost', 8088);
}

class ChatList extends StatelessWidget {
  // modify with your true address/port
  Socket? socket;
  final WebSocketChannel channel =
      IOWebSocketChannel.connect(Uri.parse('ws://localhost:8088'));

  @override
  Widget build(BuildContext context) {
    // channel.stream.listen((message) {
    //   channel.sink.add('received!');
    //   channel.sink.close(status.goingAway);
    // });

    return StreamBuilder(
        stream: channel.stream,
        builder: (context, snapshot) {
          return Scaffold(
            body: Container(
              child: Column(
                children: [
                  Text(snapshot.hasData
                      ? '${snapshot.data}'
                      : 'ssss-${snapshot.data}'),
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
                      separatorBuilder: (BuildContext context, int index) =>
                          SizedBox(height: Constants.PADDING),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}

class ChatListItem extends StatelessWidget {
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
                      lorem.substring(0, 100),
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
