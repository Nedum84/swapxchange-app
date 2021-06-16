import 'package:flutter/material.dart';

import 'colors.dart';

class Constants {
  static final double PADDING = 16;
  static final String AGORA_APP_ID = "18f66d8a4cf141c29daf271a39cf8fe2";
  static final String AGORA_TOKEN = "00618f66d8a4cf141c29daf271a39cf8fe2IACMWQ6sr3cdWBKjkP2mhuF9KMH26BR/voSfgeZSM4/3AoamEDYAAAAAEAA3rfa7AYy4YAEAAQABjLhg";

  // TEST KEYS
  static final PAYSTACK_PUBLIC_KEY = 'sk_test_9cd3e56e95f4abea6a56643e45ca3f606210effc';
  static final PAYSTACK_SECRET_KEY = 'pk_test_b76b204c7b0b2c62574f9807e0dda5a14487048e';

  // //LIVE KEYS
  // static final PAYSTACK_PUBLIC_KEY = 'pk_live_cd8470ea118572ad73108abecbc87e11536d6138';
  // static final PAYSTACK_SECRET_KEY = 'sk_live_55f3a4f67130f438f358ea2890c3bb6cfd0e746d';

  static final ANDROID_MAP_KEY = 'AIzaSyB2SmVI9__vmGe8LQmVhKtXgYwT88rRepQ';
  static final IOS_MAP_KEY = 'AIzaSyCDm9RxFcAe-2hYYFBBb9yUJEz374Xr6TA';

  static final SHARE_CONTENT = "Shopping/Swapping made easy with SwapXchange.shop. Get it on "
      "https://play.google.com/store/apps/details?id=com.app.swapxchange or visit https://swapxchange.shop";

  static final SHADOW = BoxShadow(
    color: KColors.TEXT_COLOR_LIGHT,
    blurRadius: 4.0, // has the effect of softening the shadow
    spreadRadius: 0.0, // has the effect of extending the shadow
    offset: Offset(
      0.0, // horizontal, move right 10
      0.0, // horizontal, move right 10
    ),
  );

  static final SHADOW_LIGHT = BoxShadow(
    color: KColors.TEXT_COLOR_LIGHT.withOpacity(.3),
    blurRadius: 4.0, // has the effect of softening the shadow
    spreadRadius: 0.0, // has the effect of extending the shadow
    offset: Offset(
      0.0, // horizontal, move right 10
      0.0, // horizontal, move right 10
    ),
  );
}
