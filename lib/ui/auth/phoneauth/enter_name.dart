import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/ui/auth/onboarding/grant_permission.dart';
import 'package:swapxchange/ui/components/custom_button.dart';
import 'package:swapxchange/ui/components/step_progress_view.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

class EnterName extends StatelessWidget {
  TextEditingController fullnameController = TextEditingController();
  FocusNode textFieldFocusName = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Your Name',
                  style: H1Style,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: KColors.TEXT_COLOR_LIGHT.withOpacity(.5)),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: TextField(
                    controller: fullnameController,
                    focusNode: textFieldFocusName,
                    keyboardType: TextInputType.name,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    autofocus: true,
                    style: TextStyle(
                      color: KColors.TEXT_COLOR_DARK,
                      fontWeight: FontWeight.w600,
                    ),
                    cursorColor: Colors.blueGrey,
                    decoration: InputDecoration(
                      // labelText: 'Enter phone',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding:
                          EdgeInsets.only(left: 8, bottom: 2, top: 2, right: 8),
                    ),
                  ),
                ),
                SizedBox(height: 64),
                PrimaryButton(
                  btnText: 'CONTINUE',
                  onClick: () => Get.to(() => GrantPermission(),
                      transition: Transition.rightToLeftWithFade),
                ),
              ],
            ),
          ),
          CustomBackButton(),
          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: StepProgressView(
              itemSize: 4,
              width: MediaQuery.of(context).size.width,
              curStep: 2,
              inActiveColor: KColors.TEXT_COLOR_LIGHT.withOpacity(.3),
              activeColor: KColors.PRIMARY,
            ),
          )
        ],
      ),
    );
  }
}
