
import 'package:flutter/material.dart';
import 'package:maketplace/utils/custom_colors.dart';

abstract class CustomStyles {
  static const TextStyle styleBlueUno = TextStyle(color: CustomColors.safeBlue, fontWeight: FontWeight.w700, fontSize: 24, fontFamily: "Hellix");

  static const TextStyle styleWhiteUno = TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16, fontFamily: "Hellix");
  static const TextStyle styleWhiteDos = TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16, fontFamily: "Hellix");

  static const TextStyle styleVolcanicBlueUno = TextStyle(color: CustomColors.volcanicBlue, fontWeight: FontWeight.w700, fontSize: 14, fontFamily: "Hellix");
  static const TextStyle styleVolcanicBlueDos = TextStyle(color: CustomColors.volcanicBlue, fontWeight: FontWeight.w600, fontSize: 14, fontFamily: "Hellix");
  static const TextStyle styleVolcanicBlueTres = TextStyle(color: CustomColors.volcanicBlue, fontWeight: FontWeight.w700, fontSize: 18, fontFamily: "Hellix");

  static const TextStyle styleVolcanicUno = TextStyle(color: CustomColors.volcanic, fontWeight: FontWeight.w600, fontSize: 16, fontFamily: "Hellix");
  static const TextStyle styleVolcanicDos = TextStyle(color: CustomColors.volcanicBlue, fontWeight: FontWeight.w600, fontSize: 12, fontFamily: "Hellix");

  static const TextStyle styleBlackContrastUno = TextStyle(color: CustomColors.blackContrast, fontWeight: FontWeight.w800, fontSize: 16, fontFamily: "Hellix");

}