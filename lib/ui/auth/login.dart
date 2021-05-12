import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/ui/auth/phoneauth/enter_phone.dart';
import 'package:swapxchange/ui/components/custom_button.dart';
import 'package:swapxchange/utils/styles.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/logo.jpg',
              width: Get.width / 3,
            ),
            SizedBox(height: 2),
            Text(
              'Get Started',
              style: H1Style,
            ),
            SizedBox(height: 32),
            PrimaryButton(
                btnText: 'CONTINUE WITH PHONE NUMBER',
                onClick: () => Get.to(() => EnterPhone(),
                    transition: Transition.rightToLeftWithFade)),
            SizedBox(height: 16),
            SecondaryButton(
                onClick: () => Get.to(() => EnterPhone(),
                    transition: Transition.leftToRight)),
          ],
        ),
      ),
    );
  }
}
