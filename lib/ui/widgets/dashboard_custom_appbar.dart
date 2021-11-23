import 'package:flutter/material.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/styles.dart';

class DashboardCustomAppbar extends StatelessWidget {
  final String title;
  final Widget? titleWidget;
  final IconData? icon;
  final Function()? iconClick;

  const DashboardCustomAppbar({Key? key, required this.title, this.icon, this.iconClick, this.titleWidget}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Constants.PADDING, vertical: Constants.PADDING / 2),
      child: Row(
        children: [
          Expanded(
            child: titleWidget ??
                Text(
                  title,
                  style: H1Style,
                ),
          ),
          if (icon != null)
            InkWell(
              onTap: iconClick,
              child: Icon(
                icon,
                color: KColors.TEXT_COLOR_DARK,
              ),
            )
        ],
      ),
    );
  }
}
