
import 'package:flutter/material.dart';
import 'package:maketplace/utils/custom_colors.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class CustomStyles {
  static TextStyle styleBlueUno = GoogleFonts.montserrat(textStyle: const TextStyle(fontStyle: FontStyle.normal, color: CustomColors.safeBlue, fontWeight: FontWeight.w700, fontSize: 24,));

  static TextStyle styleWhiteUno = GoogleFonts.montserrat(textStyle: const TextStyle(fontStyle: FontStyle.normal, color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16,));
  static TextStyle styleWhiteDos = GoogleFonts.montserrat(textStyle: const TextStyle(fontStyle : FontStyle.normal, color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16,));

  static TextStyle styleVolcanicBlueUno = GoogleFonts.montserrat(textStyle: const TextStyle(fontStyle: FontStyle.normal,color: CustomColors.volcanicBlue, fontWeight: FontWeight.w700, fontSize: 14,));
  static TextStyle styleVolcanicBlueDos = GoogleFonts.montserrat(textStyle: const TextStyle(fontStyle: FontStyle.normal, color: CustomColors.volcanicBlue, fontWeight: FontWeight.w600, fontSize: 14,));
  static TextStyle styleVolcanicBlueTres = GoogleFonts.montserrat(textStyle: const TextStyle(fontStyle: FontStyle.normal, color: CustomColors.volcanicBlue, fontWeight: FontWeight.w700, fontSize: 18,));

  static TextStyle styleVolcanicUno = GoogleFonts.montserrat(textStyle: const TextStyle(fontStyle: FontStyle.normal, color: CustomColors.volcanic, fontWeight: FontWeight.w600, fontSize: 16,));
  static TextStyle styleVolcanicDos = GoogleFonts.montserrat(textStyle: const TextStyle(fontStyle: FontStyle.normal, color: CustomColors.volcanicBlue, fontWeight: FontWeight.w600, fontSize: 12,));

  static TextStyle styleBlackContrastUno = GoogleFonts.montserrat(textStyle: const TextStyle(fontStyle: FontStyle.normal, color: CustomColors.blackContrast, fontWeight: FontWeight.w800, fontSize: 16,));


  static TextStyle styleMobileBlue700 = GoogleFonts.montserrat(textStyle: const TextStyle(fontStyle: FontStyle.normal, color: CustomColors.safeBlue, fontWeight: FontWeight.w700, fontSize: 12,));
  static TextStyle styleMobileBlue400 = GoogleFonts.montserrat(textStyle: const TextStyle(fontStyle: FontStyle.normal, color: CustomColors.safeBlue, fontWeight: FontWeight.w400, fontSize: 12,));

  static TextStyle styleMobileVolcanic700 = GoogleFonts.montserrat(textStyle: const TextStyle(fontStyle: FontStyle.normal, color: CustomColors.volcanic, fontWeight: FontWeight.w700, fontSize: 12, ));
  static TextStyle styleMobileVolcanic400 = GoogleFonts.montserrat(textStyle: const TextStyle(fontStyle: FontStyle.normal, color: CustomColors.volcanicBlue, fontWeight: FontWeight.w400, fontSize: 12, ));
  static TextStyle styleMobileWhite500 = GoogleFonts.montserrat(textStyle: const TextStyle(fontStyle: FontStyle.normal, color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14,));
  static TextStyle styleMobileYellow500 = GoogleFonts.montserrat(textStyle: const TextStyle(fontStyle: FontStyle.normal, color: CustomColors.energyYellow, fontWeight: FontWeight.w500, fontSize: 14, ));
  static TextStyle styleMobileVolcanicBlue18x600 = GoogleFonts.montserrat(textStyle: const TextStyle(fontStyle: FontStyle.normal, color: CustomColors.volcanicBlue, fontWeight: FontWeight.w600, fontSize: 18, ));
  static TextStyle styleMobileVolcanicWhite18x600 = GoogleFonts.montserrat(textStyle: const TextStyle(fontStyle: FontStyle.normal, color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18, ));
  static TextStyle styleMobileWhite14600 = GoogleFonts.montserrat(textStyle: const TextStyle(fontStyle: FontStyle.normal, color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14, ));
  static TextStyle styleMobileHyperlink14600 = GoogleFonts.montserrat(textStyle: const TextStyle(decoration: TextDecoration.underline, fontStyle: FontStyle.normal, color: CustomColors.safeBlue, fontWeight: FontWeight.w600, fontSize: 14, ));
}