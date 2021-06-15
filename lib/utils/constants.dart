import 'package:flutter/material.dart';

import 'colors.dart';

class Constants {
  static final double PADDING = 16;
  static final String AGORA_APP_ID = "18f66d8a4cf141c29daf271a39cf8fe2";
  static final String AGORA_TOKEN = "00618f66d8a4cf141c29daf271a39cf8fe2IACMWQ6sr3cdWBKjkP2mhuF9KMH26BR/voSfgeZSM4/3AoamEDYAAAAAEAA3rfa7AYy4YAEAAQABjLhg";

  // TEST KEYS
  static final PAYSTACK_PUBLIC_KEY = 'pk_test_5a9a6d874d1ccc9075a6ef4cb707c24f50d0223a';
  static final PAYSTACK_SECRET_KEY = 'sk_test_5f33ed9fa0e64a00ba1ec0499f889d9d9cbbee96';

  // //LIVE KEYS
  // static final PAYSTACK_PUBLIC_KEY = 'pk_live_cd8470ea118572ad73108abecbc87e11536d6138';
  // static final PAYSTACK_SECRET_KEY = 'sk_live_55f3a4f67130f438f358ea2890c3bb6cfd0e746d';

  static final SHARE_CONTENT = "iClass App is a great way to achieve superior academic results in senior secondary school or in preparation for WAEC, NECO, JAMB & POST-UTME exams. Check it out! Download at https://play.google.com/store/apps/details?id=com.app.iclass or visit https://iclass.school";

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
