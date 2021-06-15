import 'package:flutter/material.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

class ProfileItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool showBottomBorder;
  final bool showArrowRight;
  final Function() onClick;

  const ProfileItem({Key? key, required this.text, required this.icon, this.showBottomBorder = false, this.showArrowRight = true, required this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: KColors.TEXT_COLOR_LIGHT2.withOpacity(.12)),
            bottom: BorderSide(color: showBottomBorder ? KColors.TEXT_COLOR_LIGHT2.withOpacity(.12) : Colors.transparent),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: KColors.TEXT_COLOR.withOpacity(1),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: StyleNormal.copyWith(color: KColors.TEXT_COLOR_DARK),
              ),
            ),
            SizedBox(width: 4),
            !showArrowRight
                ? Container()
                : CircleAvatar(
                    backgroundColor: Color(0xffE4E5E8),
                    radius: 10,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: KColors.TEXT_COLOR,
                      size: 10,
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
