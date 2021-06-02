import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swapxchange/utils/colors.dart';

class QuestionMark extends StatelessWidget {
  final double? width;
  final double? height;
  final double? radius;
  final Color? bgColor;
  final Color? iconColor;

  const QuestionMark({Key? key, this.width, this.height, this.bgColor, this.iconColor, this.radius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 60,
      height: height ?? 60,
      decoration: BoxDecoration(
        color: bgColor ?? KColors.TEXT_COLOR.withOpacity(.1),
        borderRadius: BorderRadius.circular(radius ?? 6),
      ),
      child: Icon(
        FontAwesomeIcons.question,
        color: iconColor ?? Colors.black26,
      ),
    );
  }
}
