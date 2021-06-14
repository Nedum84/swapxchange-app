import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swapxchange/utils/colors.dart';

final TextStyle Default = GoogleFonts.montserrat();

final TextStyle H1Style = Default.copyWith(
  color: KColors.TEXT_COLOR_DARK,
  fontSize: 24,
  fontWeight: FontWeight.bold,
);

final TextStyle H2Style = Default.copyWith(
  color: KColors.TEXT_COLOR,
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

final TextStyle H3Style = Default.copyWith(
  color: KColors.TEXT_COLOR,
  fontSize: 16,
  fontWeight: FontWeight.bold,
);
// final TextStyle StyleNormal = Default.copyWith(
//   color: KColors.TEXT_COLOR,
//   fontSize: 14,
// );
final TextStyle StyleNormal = Default.copyWith(
  fontSize: 14,
  fontStyle: FontStyle.normal,
  color: KColors.TEXT_COLOR,
);

final TextStyle StyleProductTitle = Default.copyWith(
  color: KColors.TEXT_COLOR,
  fontSize: 16,
);

final TextStyle StyleProductPrice = Default.copyWith(
  color: KColors.TEXT_COLOR_DARK,
  fontSize: 12,
  fontWeight: FontWeight.bold,
);

final TextStyle StyleCategorySubTitle = Default.copyWith(
  color: KColors.TEXT_COLOR.withOpacity(.5),
  fontSize: 12,
);
