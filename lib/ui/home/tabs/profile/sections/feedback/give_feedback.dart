import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/ui/widgets/custom_button.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

class GiveFeedback extends StatelessWidget {
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.WHITE_GREY,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: KColors.TEXT_COLOR_DARK,
          ),
          onPressed: () => Get.back(),
        ),
        centerTitle: false,
        title: Text(
          'Give Feedback',
          style: H1Style,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: KColors.TEXT_COLOR_LIGHT.withOpacity(.5), width: 1),
              ),
              child: TextField(
                controller: messageController,
                keyboardType: TextInputType.multiline,
                maxLines: 6,
                style: TextStyle(
                  color: KColors.TEXT_COLOR_DARK,
                  fontWeight: FontWeight.w600,
                ),
                cursorColor: Colors.blueGrey,
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                  hintStyle: StyleNormal.copyWith(
                    color: KColors.TEXT_COLOR,
                    fontWeight: FontWeight.w500,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 8, bottom: 2, top: 2, right: 8),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            PrimaryButton(onClick: () => null, btnText: 'Submit')
          ],
        ),
      ),
    );
  }
}
