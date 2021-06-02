import 'package:flutter/material.dart';

import 'colors.dart';

class Constants {
  static final double PADDING = 16;
  static final String AGORA_APP_ID = "18f66d8a4cf141c29daf271a39cf8fe2";
  static final String AGORA_TOKEN = "00618f66d8a4cf141c29daf271a39cf8fe2IACMWQ6sr3cdWBKjkP2mhuF9KMH26BR/voSfgeZSM4/3AoamEDYAAAAAEAA3rfa7AYy4YAEAAQABjLhg";

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
