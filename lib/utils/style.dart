
import 'package:flutter/material.dart';
import 'package:maketplace/utils/custom_colors.dart';

abstract class CustomStyles {
  static const TextStyle styleBlueUno = TextStyle(fontStyle: FontStyle.normal, color: CustomColors.safeBlue, fontWeight: FontWeight.w700, fontSize: 24, fontFamily: "Hellix");

  static const TextStyle styleWhiteUno = TextStyle(fontStyle: FontStyle.normal, color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16, fontFamily: "Hellix");
  static const TextStyle styleWhiteDos = TextStyle(fontStyle : FontStyle.normal, color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16, fontFamily: "Hellix");

  static const TextStyle styleVolcanicBlueUno = TextStyle(fontStyle: FontStyle.normal,color: CustomColors.volcanicBlue, fontWeight: FontWeight.w700, fontSize: 14, fontFamily: "Hellix");
  static const TextStyle styleVolcanicBlueDos = TextStyle(fontStyle: FontStyle.normal, color: CustomColors.volcanicBlue, fontWeight: FontWeight.w600, fontSize: 14, fontFamily: "Hellix");
  static const TextStyle styleVolcanicBlueTres = TextStyle(fontStyle: FontStyle.normal, color: CustomColors.volcanicBlue, fontWeight: FontWeight.w700, fontSize: 18, fontFamily: "Hellix");

  static const TextStyle styleVolcanicUno = TextStyle(fontStyle: FontStyle.normal, color: CustomColors.volcanic, fontWeight: FontWeight.w600, fontSize: 16, fontFamily: "Hellix");
  static const TextStyle styleVolcanicDos = TextStyle(fontStyle: FontStyle.normal, color: CustomColors.volcanicBlue, fontWeight: FontWeight.w600, fontSize: 12, fontFamily: "Hellix");

  static const TextStyle styleBlackContrastUno = TextStyle(fontStyle: FontStyle.normal, color: CustomColors.blackContrast, fontWeight: FontWeight.w800, fontSize: 16, fontFamily: "Hellix");


  static const TextStyle styleMobileBlue700 = TextStyle(fontStyle: FontStyle.normal, color: CustomColors.safeBlue, fontWeight: FontWeight.w700, fontSize: 12, fontFamily: "Hellix");
  static const TextStyle styleMobileBlue400 = TextStyle(fontStyle: FontStyle.normal, color: CustomColors.safeBlue, fontWeight: FontWeight.w400, fontSize: 12, fontFamily: "Hellix");

  static const TextStyle styleMobileVolcanic700 = TextStyle(fontStyle: FontStyle.normal, color: CustomColors.volcanic, fontWeight: FontWeight.w700, fontSize: 12, fontFamily: "Hellix");
  static const TextStyle styleMobileVolcanic400 = TextStyle(fontStyle: FontStyle.normal, color: CustomColors.volcanicBlue, fontWeight: FontWeight.w400, fontSize: 12, fontFamily: "Hellix");
  static const TextStyle styleMobileWhite500 = TextStyle(fontStyle: FontStyle.normal, color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14, fontFamily: "Hellix");
  static const TextStyle styleMobileVolcanicBlue18x600 = TextStyle(fontStyle: FontStyle.normal, color: CustomColors.volcanicBlue, fontWeight: FontWeight.w600, fontSize: 18, fontFamily: "Hellix");
  static const TextStyle styleMobileWhite14600 = TextStyle(fontStyle: FontStyle.normal, color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14, fontFamily: "Hellix");
  static const TextStyle styleMobileHyperlink14600 = TextStyle(decoration: TextDecoration.underline, fontStyle: FontStyle.normal, color: CustomColors.safeBlue, fontWeight: FontWeight.w600, fontSize: 14, fontFamily: "Hellix");
}