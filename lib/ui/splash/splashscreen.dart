import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/category_controller.dart';
import 'package:swapxchange/controllers/coins_controller.dart';
import 'package:swapxchange/controllers/sub_category_controller.dart';
import 'package:swapxchange/repository/auth_repo.dart';
import 'package:swapxchange/ui/auth/login.dart';
import 'package:swapxchange/utils/alert_utils.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthRepo _authRepo = AuthRepo();

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  _initialize() async {
    Get.put(CategoryController());
    Get.put(SubCategoryController());
    CoinsController.to.getBalance();
    await Future.delayed(Duration(seconds: 5));
    // final u = _authRepo.getCurrentUser();
    // if (u == null) {
    Get.offAll(() => Login(), transition: Transition.leftToRightWithFade);
    // } else {
    //   authenticateUser(u);
    // }
  }

  void authenticateUser(User user) async {
    _authRepo.addDataToDb(
      firebaseUser: user,
      onSuccess: (appUser, tokens) {
        print(tokens);
        print(appUser);
      },
      onError: (er) {
        AlertUtils.toast("$er");
        print(er);
      },
    );
  }

  var colorizeColors = [
    KColors.TEXT_COLOR_LIGHT,
    KColors.TEXT_COLOR_DARK,
    KColors.TEXT_COLOR,
    KColors.SECONDARY,
    KColors.TEXT_COLOR,
    KColors.PRIMARY,
  ];

  var colorizeTextStyle = TextStyle(
    fontSize: 50.0,
    fontFamily: 'Horizon',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/logo_text1.png',
              width: Get.width / 1.5,
            ),
            // Text(
            //   'Find & Swap Stuff nearby',
            //   style: TextStyle(color: KColors.TEXT_COLOR),
            // ),
            AnimatedTextKit(
              repeatForever: true,
              isRepeatingAnimation: true,
              pause: Duration(milliseconds: 50),
              animatedTexts: [
                ColorizeAnimatedText(
                  'Find & Swap Stuff nearby',
                  textStyle: StyleNormal.copyWith(fontSize: 16),
                  colors: colorizeColors,
                  speed: Duration(milliseconds: 500),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
