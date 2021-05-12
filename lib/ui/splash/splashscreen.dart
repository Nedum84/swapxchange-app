import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/ui/auth/login.dart';
import 'package:swapxchange/utils/colors.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      Get.offAll(Login(), transition: Transition.zoom);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/logo_text1.png',
              width: Get.width / 2,
            ),
            Text(
              'Find & Swap Stuff nearby',
              style: TextStyle(color: KColors.TEXT_COLOR),
            ),
          ],
        ),
      ),
    );
  }
}
