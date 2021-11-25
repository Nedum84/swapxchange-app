import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'colors.dart';

class Constants {
  static final double PADDING = 16;
  static final String AGORA_APP_ID = dotenv.env['AGORA_APP_ID']!;
  static final String AGORA_TOKEN = dotenv.env['AGORA_TOKEN']!;

  // TEST KEYS
  // static final PAYSTACK_PUBLIC_KEY = dotenv.env['PAYSTACK_PUBLIC_KEY_TEST']!;
  // static final PAYSTACK_SECRET_KEY = dotenv.env['PAYSTACK_SECRET_KEY_TEST']!;

  // //LIVE KEYS
  static final PAYSTACK_PUBLIC_KEY = dotenv.env['PAYSTACK_PUBLIC_KEY']!;
  static final PAYSTACK_SECRET_KEY = dotenv.env['PAYSTACK_SECRET_KEY']!;

  static final ANDROID_MAP_KEY = dotenv.env['ANDROID_MAP_KEY']!;
  static final IOS_MAP_KEY = dotenv.env['IOS_MAP_KEY']!;

  //FCM KEYS
  static final ANDROID_FCM_KEY = dotenv.env['ANDROID_FCM_KEY']!;
  static final IOS_FCM_KEY = dotenv.env['IOS_FCM_KEY']!;

  // static final String RSA_PUBLIC_KEY = dotenv.env['RSA_PUBLIC_KEY_TEST']!;
  static final String RSA_PUBLIC_KEY = dotenv.env['RSA_PUBLIC_KEY']!;

  // static final String CLOUDINARY_SECRET = dotenv.env['CLOUDINARY_SECRET_TEST']!;
  // static final String CLOUDINARY_KEY = dotenv.env['CLOUDINARY_KEY_TEST']!;
  // static final String CLOUDINARY_CLOUD_NAME = "nellyinc";

  static final String CLOUDINARY_SECRET = dotenv.env['CLOUDINARY_SECRET']!;
  static final String CLOUDINARY_KEY = dotenv.env['CLOUDINARY_KEY']!;
  static final String CLOUDINARY_CLOUD_NAME = "swapxchange";

  static final SHARE_CONTENT = "Shopping/Swapping made easy with SwapXchange.shop. Get it on "
      "https://play.google.com/store/apps/details?id=com.app.swapxchange or visit https://swapxchange.shop";

  static final SHADOW = BoxShadow(
    color: KColors.TEXT_COLOR_LIGHT,
    blurRadius: 4.0,
    spreadRadius: 0.0,
    offset: Offset(0.0, 0.0),
  );

  static final SHADOW_LIGHT = BoxShadow(
    color: KColors.TEXT_COLOR_LIGHT.withOpacity(.3),
    blurRadius: 4.0,
    spreadRadius: 0.0,
    offset: Offset(0.0, 0.0),
  );

  static final double APPBAR_HEIGHT = AppBar().preferredSize.height;
}
