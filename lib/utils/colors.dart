import 'package:flutter/material.dart';

class KColors {
  static final PRIMARY = Color(0xff00a14b);
  static final SECONDARY = Color(0xffffde17);
  static final TEXT_COLOR_DARK = Color(0xff0D1F2D);
  static final TEXT_COLOR_MEDIUM = Color(0xff494949);
  // static final TEXT_COLOR = Color(0xff546A7B);
  static final TEXT_COLOR = Color(0xff515C70);
  static final TEXT_COLOR_LIGHT = Color(0xff9EA3B0);
  static final TEXT_COLOR_LIGHT2 = Color(0xff999799);
  static final TEXT_COLOR_ACCENT = Color(0xff7C7A7A);
  static final BLUE = Color(0xff015CE6);
  static final RED = Color(0xffde3723);
  static final WHITE_GREY = Color(0xffF2F2F2);
  static final WHITE_GREY2 = Color(0xffEEF2F4);
  static final PRIMARY2 = Colors.white.withOpacity(.5);
}

final Map<int, Color> colorMap = {
  50: Color(0xff00a14b).withOpacity(.05),
  100: Color(0xff00a14b).withOpacity(.1),
  200: Color(0xff00a14b).withOpacity(.2),
  300: Color(0xff00a14b).withOpacity(.3),
  400: Color(0xff00a14b).withOpacity(.4),
  500: Color(0xff00a14b).withOpacity(.5),
  600: Color(0xff00a14b).withOpacity(.6),
  700: Color(0xff00a14b).withOpacity(.7),
  800: Color(0xff00a14b).withOpacity(.8),
  900: Color(0xff00a14b),
};
final MaterialColor colorCustom = MaterialColor(0xff00a14b, colorMap);
