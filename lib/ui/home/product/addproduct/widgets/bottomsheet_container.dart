import 'package:flutter/material.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

class BottomSheetContainer extends StatelessWidget {
  final String title;
  final String? subtitle;
  final double? sheetHeight;
  final Widget child;

  const BottomSheetContainer({
    Key? key,
    required this.title,
    this.subtitle,
    required this.child,
    this.sheetHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        height: sheetHeight ?? MediaQuery.of(context).size.height - 60,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Align(
              child: Container(
                width: 80,
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: KColors.TEXT_COLOR.withOpacity(.15),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: H1Style,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            if (subtitle != null)
              Text(
                subtitle!,
                style: StyleNormal.copyWith(),
                textAlign: TextAlign.center,
              ),
            SizedBox(height: 8),
            Divider(
              color: KColors.TEXT_COLOR.withOpacity(.2),
            ),
            child
          ],
        ),
      ),
    );
  }
}
