import 'package:flutter/material.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/styles.dart';

class DashboardCustomAppbar extends StatelessWidget {
  final String title;
  final Widget? actionBtn;

  const DashboardCustomAppbar({Key? key, required this.title, this.actionBtn})
      : super(key: key);
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
          actionBtn ?? Container()
        ],
      ),
    );
  }
}
