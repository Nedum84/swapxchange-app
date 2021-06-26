import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

class CustomAppbar2 extends StatelessWidget {
  final String title;
  final Widget? actionBtn;

  const CustomAppbar2({Key? key, required this.title, this.actionBtn}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          InkWell(
            onTap: () => Get.back(),
            child: Icon(
              Icons.arrow_back_ios_outlined,
              color: KColors.TEXT_COLOR_DARK,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: H1Style.copyWith(fontSize: 18),
            ),
          ),
          actionBtn ?? Container()
        ],
      ),
    );
  }
}

class CustomAppbar extends StatelessWidget {
  final String title;
  final List<Widget>? actionBtn;
  final bool makeTransparent;
  final double? titleFontSize;
  final Color? shadowColor;

  const CustomAppbar({
    Key? key,
    required this.title,
    this.actionBtn,
    this.makeTransparent = false,
    this.titleFontSize,
    this.shadowColor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: makeTransparent ? Colors.transparent : Colors.white,
      shadowColor: shadowColor ?? Colors.transparent,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: KColors.TEXT_COLOR_DARK,
        ),
        onPressed: () => Get.back(),
      ),
      centerTitle: false,
      title: Text(
        '$title',
        style: H1Style.copyWith(fontSize: titleFontSize ?? 24),
      ),
      actions: actionBtn ?? [Container()],
    );
  }
}
