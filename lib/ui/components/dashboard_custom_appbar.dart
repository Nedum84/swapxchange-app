import 'package:flutter/material.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/styles.dart';

class DashboardCustomAppbar extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Function()? iconClick;

  const DashboardCustomAppbar({Key? key, required this.title, this.icon, this.iconClick}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Constants.PADDING),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: H1Style,
            ),
          ),
          if (icon != null)
            InkWell(
              onTap: () => print('cxcxcx----'),
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
