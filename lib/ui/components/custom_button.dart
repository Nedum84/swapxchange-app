import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/styles.dart';

class PrimaryButton extends StatelessWidget {
  final Function() onClick;
  final String btnText;
  final Color? bgColor;
  final Color? textColor;
  final Color? arrowColor;
  const PrimaryButton(
      {Key? key,
      required this.onClick,
      required this.btnText,
      this.bgColor,
      this.textColor,
      this.arrowColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: bgColor ?? KColors.PRIMARY,
          boxShadow: [Constants.SHADOW],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            circle(isBlank: true),
            Text(
              btnText,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
            circle(),
          ],
        ),
      ),
    );
  }

  Widget circle({isBlank: false}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: isBlank ? Colors.transparent : textColor ?? Colors.white,
      ),
      child: Icon(
        Icons.keyboard_arrow_right_rounded,
        color: isBlank ? Colors.transparent : arrowColor ?? KColors.PRIMARY,
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final Function() onClick;

  const SecondaryButton({Key? key, required this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
          boxShadow: [Constants.SHADOW],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            circle(isBlank: true),
            Text(
              'SIGN IN WITH FACEBOOK',
              style: TextStyle(
                color: KColors.BLUE,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
            circle(),
          ],
        ),
      ),
    );
  }

  Widget circle({isBlank: false}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
      ),
      child: Icon(
        Icons.keyboard_arrow_right_rounded,
        color: isBlank ? Colors.transparent : KColors.BLUE,
      ),
    );
  }
}

class CustomBackButton extends StatelessWidget {
  final Color? color;

  const CustomBackButton({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 60,
      left: 24,
      child: BackButton(
        color: color ?? KColors.PRIMARY,
        onPressed: () => Get.back(),
      ),
    );
  }
}

class ButtonSmall extends StatelessWidget {
  final Function() onClick;
  final String text;
  final Color? bgColor;
  final Color? textColor;
  final double? radius;
  final double? py;

  const ButtonSmall(
      {Key? key,
      required this.onClick,
      required this.text,
      this.bgColor,
      this.textColor,
      this.radius,
      this.py})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: py ?? 4, horizontal: 12),
        decoration: BoxDecoration(
          color: bgColor ?? KColors.SECONDARY,
          borderRadius: BorderRadius.circular(radius ?? 20),
        ),
        child: Text(
          text,
          style: StyleNormal.copyWith(
            color: textColor ?? KColors.TEXT_COLOR_DARK,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class ButtonOutline extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function() onClick;

  const ButtonOutline(
      {Key? key,
      required this.title,
      required this.icon,
      required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: KColors.TEXT_COLOR_LIGHT2.withOpacity(.5)),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: KColors.TEXT_COLOR,
            ),
            Text(
              title,
              style: StyleNormal,
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonOutline2 extends StatelessWidget {
  final String title;
  final Color? titleColor;
  final Color? borderColor;
  final double? py;
  final Function() onClick;

  const ButtonOutline2(
      {Key? key,
      required this.title,
      this.titleColor,
      required this.onClick,
      this.borderColor,
      this.py})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: py ?? 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
              color: borderColor ?? KColors.TEXT_COLOR_LIGHT2.withOpacity(.5)),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: StyleNormal.copyWith(color: titleColor ?? KColors.TEXT_COLOR),
        ),
      ),
    );
  }
}
