import 'package:flutter/material.dart';
import 'package:swapxchange/utils/colors.dart';

class CallChatItem extends StatelessWidget {
  final String imgPath;
  final String title;
  final Function() onClick;

  const CallChatItem({Key? key, required this.imgPath, required this.title, required this.onClick}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Row(
        children: [
          Image.asset(
            imgPath,
            width: 30,
            height: 30,
          ),
          SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: KColors.PRIMARY,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}
