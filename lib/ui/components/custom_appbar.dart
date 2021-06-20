import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

class CustomAppbar extends StatelessWidget {
  final String title;
  final Widget? actionBtn;

  const CustomAppbar({Key? key, required this.title, this.actionBtn}) : super(key: key);
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
