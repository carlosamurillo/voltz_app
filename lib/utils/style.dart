import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maketplace/keys_model.dart';

abstract class CustomStyles {
  static double mobileBreak = 722;
  static double desktopBreak = 1109;
  static double mobileHeaderHeight = 60;
  static double desktopHeaderHeight = 80;

  static TextStyle styleBlueUno = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontStyle: FontStyle.normal,
    color: AppKeys().customColors!.safeBlue,
    fontWeight: FontWeight.w700,
    fontSize: 24,
  ));

  static TextStyle styleWhiteUno = GoogleFonts.montserrat(
      textStyle: const TextStyle(
    fontStyle: FontStyle.normal,
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 16,
  ));
  static TextStyle styleWhiteDos = GoogleFonts.montserrat(
      textStyle: const TextStyle(
    fontStyle: FontStyle.normal,
    color: Colors.white,
    fontWeight: FontWeight.w800,
    fontSize: 16,
  ));

  static TextStyle styleVolcanicBlueUno = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontStyle: FontStyle.normal,
    color: AppKeys().customColors!.volcanicBlue,
    fontWeight: FontWeight.w700,
    fontSize: 14,
  ));
  static TextStyle styleVolcanicBlueDos = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontStyle: FontStyle.normal,
    color: AppKeys().customColors!.volcanicBlue,
    fontWeight: FontWeight.w600,
    fontSize: 14,
  ));
  static TextStyle styleVolcanicBlueTres = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontStyle: FontStyle.normal,
    color: AppKeys().customColors!.volcanicBlue,
    fontWeight: FontWeight.w700,
    fontSize: 18,
  ));
  static TextStyle styleVolcanic32x700 = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontStyle: FontStyle.normal,
    color: AppKeys().customColors!.volcanicBlue,
    fontWeight: FontWeight.w700,
    fontSize: 32,
  ));

  static TextStyle styleVolcanicUno = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontStyle: FontStyle.normal,
    color: AppKeys().customColors!.volcanic,
    fontWeight: FontWeight.w600,
    fontSize: 16,
  ));
  static TextStyle styleVolcanicDos = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontStyle: FontStyle.normal,
    color: AppKeys().customColors!.volcanicBlue,
    fontWeight: FontWeight.w600,
    fontSize: 12,
  ));

  static TextStyle styleBlackContrastUno = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontStyle: FontStyle.normal,
    color: AppKeys().customColors!.blackContrast,
    fontWeight: FontWeight.w800,
    fontSize: 16,
  ));

  static TextStyle styleBlue14x500 = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontStyle: FontStyle.normal,
    color: AppKeys().customColors!.safeBlue,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    decoration: TextDecoration.underline,
  ));
  static TextStyle styleVolcanic14x500 = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontStyle: FontStyle.normal,
    color: AppKeys().customColors!.volcanicBlue,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.1,
  ));
  static TextStyle styleBlue14x700 =
      GoogleFonts.montserrat(textStyle: TextStyle(fontStyle: FontStyle.normal, color: AppKeys().customColors!.safeBlue, fontWeight: FontWeight.w700, fontSize: 14, height: 1.1));

  static TextStyle styleMobileBlue700 = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontStyle: FontStyle.normal,
    color: AppKeys().customColors!.safeBlue,
    fontWeight: FontWeight.w700,
    fontSize: 12,
  ));
  static TextStyle styleMobileBlue400 = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontStyle: FontStyle.normal,
    color: AppKeys().customColors!.safeBlue,
    fontWeight: FontWeight.w400,
    fontSize: 12,
  ));

  static TextStyle styleMobileVolcanic700 = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontStyle: FontStyle.normal,
    color: AppKeys().customColors!.volcanic,
    fontWeight: FontWeight.w700,
    fontSize: 12,
  ));
  static TextStyle styleMobileVolcanic400 = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontStyle: FontStyle.normal,
    color: AppKeys().customColors!.volcanicBlue,
    fontWeight: FontWeight.w400,
    fontSize: 12,
  ));
  static TextStyle styleMobileWhite500 = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontStyle: FontStyle.normal,
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontSize: 14,
  ));
  static TextStyle styleMobileYellow500 = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontStyle: FontStyle.normal,
    color: AppKeys().customColors!.energyColor,
    fontWeight: FontWeight.w500,
    fontSize: 14,
  ));
  static TextStyle styleMobileVolcanicBlue15x500 = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontStyle: FontStyle.normal,
    color: AppKeys().customColors!.volcanicBlue,
    fontWeight: FontWeight.w500,
    fontSize: 15,
  ));
  static TextStyle styleMobileVolcanicBlue15x700 = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontStyle: FontStyle.normal,
    color: AppKeys().customColors!.volcanicBlue,
    fontWeight: FontWeight.w700,
    fontSize: 15,
  ));
  static TextStyle styleMobileVolcanicWhite15x600 = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontStyle: FontStyle.normal,
    color: Colors.white,
    fontWeight: FontWeight.w600,
    fontSize: 15,
  ));
  static TextStyle styleMobileWhite14600 = GoogleFonts.montserrat(
      textStyle: const TextStyle(
    fontStyle: FontStyle.normal,
    color: Colors.white,
    fontWeight: FontWeight.w600,
    fontSize: 14,
  ));
  static TextStyle styleMobileHyperlink14600 = GoogleFonts.montserrat(
      textStyle: TextStyle(
    decoration: TextDecoration.underline,
    fontStyle: FontStyle.normal,
    color: AppKeys().customColors!.safeBlue,
    fontWeight: FontWeight.w600,
    fontSize: 14,
  ));
  static TextStyle styleMobileVolcanic15x600 = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontStyle: FontStyle.normal,
    color: AppKeys().customColors!.volcanic,
    fontWeight: FontWeight.w600,
    fontSize: 15,
  ));

  static TextStyle styleMuggleGray18x600 = GoogleFonts.montserrat(
    textStyle:
        TextStyle(fontStyle: FontStyle.normal, color: AppKeys().customColors!.muggleGray_2, fontWeight: FontWeight.w600, fontSize: 18, height: 1.2, overflow: TextOverflow.clip),
  );
  static TextStyle styleMuggleGray_414x400 = GoogleFonts.montserrat(
    textStyle:
        TextStyle(fontStyle: FontStyle.normal, color: AppKeys().customColors!.muggleGray_4, fontWeight: FontWeight.w400, fontSize: 14, height: 1.2, overflow: TextOverflow.clip),
  );
  static TextStyle styleMuggleGray_416x700 = GoogleFonts.montserrat(
    textStyle:
        TextStyle(fontStyle: FontStyle.normal, color: AppKeys().customColors!.muggleGray_4, fontWeight: FontWeight.w700, fontSize: 16, height: 1.2, overflow: TextOverflow.clip),
  );
  static TextStyle styleWhite16x600 = GoogleFonts.montserrat(
    textStyle: TextStyle(fontStyle: FontStyle.normal, color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16, height: 1.2, overflow: TextOverflow.clip),
  );
  static TextStyle styleWhite14x400 = GoogleFonts.montserrat(
    textStyle: TextStyle(fontStyle: FontStyle.normal, color: Colors.white, fontWeight: FontWeight.w400, fontSize: 14, height: 1.2, overflow: TextOverflow.clip),
  );
  static TextStyle styleWhite26x400 = GoogleFonts.montserrat(
    textStyle: const TextStyle(fontStyle: FontStyle.normal, color: Colors.white, fontWeight: FontWeight.w400, fontSize: 26, height: 1.2, overflow: TextOverflow.clip),
  );
  static TextStyle styleVolcanic14x400 = GoogleFonts.montserrat(
      textStyle: TextStyle(fontStyle: FontStyle.normal, color: AppKeys().customColors!.volcanicBlue, fontWeight: FontWeight.w400, fontSize: 14, overflow: TextOverflow.clip));
  static TextStyle styleSafeBlue16x600 = GoogleFonts.montserrat(
      textStyle: TextStyle(fontStyle: FontStyle.normal, color: AppKeys().customColors!.safeBlue, fontWeight: FontWeight.w600, fontSize: 16, overflow: TextOverflow.clip));
  static TextStyle styleSafeBlue14x400 = GoogleFonts.montserrat(
      textStyle: TextStyle(fontStyle: FontStyle.normal, color: AppKeys().customColors!.safeBlue, fontWeight: FontWeight.w400, fontSize: 14, overflow: TextOverflow.clip));
  static TextStyle styleMuggleGray_416x600Tachado = GoogleFonts.montserrat(
      textStyle: TextStyle(
          fontStyle: FontStyle.normal,
          color: AppKeys().customColors!.muggleGray_4,
          fontWeight: FontWeight.w600,
          fontSize: 16,
          overflow: TextOverflow.clip,
          decoration: TextDecoration.lineThrough));

  static TextStyle styleVolcanic16x400 = GoogleFonts.montserrat(
    textStyle:
        TextStyle(fontStyle: FontStyle.normal, color: AppKeys().customColors!.volcanicBlue, fontWeight: FontWeight.w400, fontSize: 16, height: 1.2, overflow: TextOverflow.clip),
  );
  static TextStyle styleRedAlert16x400 = GoogleFonts.montserrat(
    textStyle: TextStyle(fontStyle: FontStyle.normal, color: AppKeys().customColors!.redAlert, fontWeight: FontWeight.w400, fontSize: 16, height: 1.2, overflow: TextOverflow.clip),
  );
  static TextStyle styleRedAlert16x400Underline = GoogleFonts.montserrat(
    textStyle: TextStyle(
        fontStyle: FontStyle.normal,
        color: AppKeys().customColors!.redAlert,
        fontWeight: FontWeight.w400,
        fontSize: 16,
        height: 1.2,
        overflow: TextOverflow.clip,
        decoration: TextDecoration.underline),
  );

  static TextStyle styleMuggleGray_416x400 = GoogleFonts.montserrat(
    textStyle:
        TextStyle(fontStyle: FontStyle.normal, color: AppKeys().customColors!.muggleGray_4, fontWeight: FontWeight.w400, fontSize: 16, height: 1.2, overflow: TextOverflow.clip),
  );
  static TextStyle styleMuggleGray_416x600 = GoogleFonts.montserrat(
    textStyle:
        TextStyle(fontStyle: FontStyle.normal, color: AppKeys().customColors!.muggleGray_4, fontWeight: FontWeight.w600, fontSize: 16, height: 1.2, overflow: TextOverflow.clip),
  );
  static TextStyle styleEnergyYellow_416x600 = GoogleFonts.montserrat(
    textStyle:
        TextStyle(fontStyle: FontStyle.normal, color: AppKeys().customColors!.energyColor, fontWeight: FontWeight.w600, fontSize: 16, height: 1.2, overflow: TextOverflow.clip),
  );

  static TextStyle styleVolcanic20700 = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontStyle: FontStyle.normal,
    color: AppKeys().customColors!.volcanicBlue,
    fontWeight: FontWeight.w700,
    fontSize: 20,
  ));
  static TextStyle styleSafeBlue24700 = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontStyle: FontStyle.normal,
    color: AppKeys().customColors!.safeBlue,
    fontWeight: FontWeight.w700,
    fontSize: 24,
  ));
  static TextStyle styleVolcanic16600 = GoogleFonts.montserrat(
      textStyle: TextStyle(fontStyle: FontStyle.normal, color: AppKeys().customColors!.volcanicBlue, fontWeight: FontWeight.w600, fontSize: 16, overflow: TextOverflow.clip));

  static TextStyle styleWhite18700 = GoogleFonts.montserrat(
      textStyle: const TextStyle(
    fontStyle: FontStyle.normal,
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 18,
  ));
  static TextStyle styleWhite16400 = GoogleFonts.montserrat(
      textStyle: const TextStyle(
    fontStyle: FontStyle.normal,
    color: Colors.white,
    fontWeight: FontWeight.w400,
    fontSize: 16,
  ));
  static TextStyle styleWhite16x600Underline = GoogleFonts.montserrat(
    textStyle: const TextStyle(
        fontStyle: FontStyle.normal,
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 16,
        height: 1.2,
        overflow: TextOverflow.clip,
        decoration: TextDecoration.underline),
  );
  static TextStyle styleEnergyYellow14x500Underline = GoogleFonts.montserrat(
    textStyle: TextStyle(
        fontStyle: FontStyle.normal,
        color: AppKeys().customColors!.energyColor,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        height: 1.0,
        overflow: TextOverflow.clip,
        decoration: TextDecoration.underline),
  );
  static TextStyle styleMuggleGray_214x400Underline = GoogleFonts.montserrat(
    textStyle: TextStyle(
        fontStyle: FontStyle.normal,
        color: AppKeys().customColors!.muggleGray_2,
        fontWeight: FontWeight.w400,
        fontSize: 14,
        height: 1.0,
        overflow: TextOverflow.clip,
        decoration: TextDecoration.underline),
  );
  static TextStyle styleMuggleGray_414x600 = GoogleFonts.montserrat(
    textStyle:
        TextStyle(fontStyle: FontStyle.normal, color: AppKeys().customColors!.muggleGray_4, fontWeight: FontWeight.w600, fontSize: 14, height: 1.2, overflow: TextOverflow.clip),
  );

  static TextStyle styleSafeBlue14x600 = GoogleFonts.montserrat(
    textStyle: TextStyle(fontStyle: FontStyle.normal, color: AppKeys().customColors!.safeBlue, fontWeight: FontWeight.w600, fontSize: 14, height: 1.2, overflow: TextOverflow.clip),
  );
  static TextStyle styleMuggleGray_418x400 = GoogleFonts.montserrat(
    textStyle:
        TextStyle(fontStyle: FontStyle.normal, color: AppKeys().customColors!.muggleGray_4, fontWeight: FontWeight.w400, fontSize: 18, height: 1.2, overflow: TextOverflow.clip),
  );
  static TextStyle styleTransparent = GoogleFonts.montserrat(
    textStyle: const TextStyle(
        fontStyle: FontStyle.normal,
        color: Colors.transparent,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        height: 1.0,
        overflow: TextOverflow.clip,
        decoration: TextDecoration.underline),
  );

  static TextStyle styleEnergyYellow14x400 = GoogleFonts.montserrat(
    textStyle: TextStyle(
      fontStyle: FontStyle.normal,
      color: AppKeys().customColors!.energyColor,
      fontWeight: FontWeight.w400,
      fontSize: 14,
      height: 1.0,
      overflow: TextOverflow.clip,
    ),
  );

  static TextStyle styleVolcanicBlue12600 = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontStyle: FontStyle.normal,
    color: AppKeys().customColors!.volcanicBlue,
    fontWeight: FontWeight.w600,
    fontSize: 20,
  ));
  static TextStyle styleSafeBlue22600 = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontStyle: FontStyle.normal,
    color: AppKeys().customColors!.safeBlue,
    fontWeight: FontWeight.w600,
    fontSize: 22,
  ));
  static TextStyle styleVolcanic14300WithLineThrough = GoogleFonts.montserrat(
      textStyle: TextStyle(
          fontStyle: FontStyle.normal,
          color: AppKeys().customColors!.volcanicBlue,
          fontWeight: FontWeight.w300,
          fontSize: 14,
          overflow: TextOverflow.clip,
          decoration: TextDecoration.lineThrough));
  static TextStyle styleVolcanic14300 = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontStyle: FontStyle.normal,
    color: AppKeys().customColors!.volcanicBlue,
    fontWeight: FontWeight.w300,
    fontSize: 14,
    overflow: TextOverflow.clip,
  ));
  static TextStyle styleVolcanic14400 = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontStyle: FontStyle.normal,
    color: AppKeys().customColors!.volcanicBlue,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    overflow: TextOverflow.clip,
  ));
  static TextStyle styleWhite24x700 = GoogleFonts.montserrat(
    textStyle: const TextStyle(fontStyle: FontStyle.normal, color: Colors.white, fontWeight: FontWeight.w700, fontSize: 24, height: 1.2, overflow: TextOverflow.clip),
  );
  static TextStyle styleSafeBlue14600Underline = GoogleFonts.montserrat(
      textStyle: TextStyle(fontStyle: FontStyle.normal, color: AppKeys().customColors!.safeBlue, fontWeight: FontWeight.w600, fontSize: 14, decoration: TextDecoration.underline));

  static TextStyle styleWhite22x700 = GoogleFonts.montserrat(
    textStyle: const TextStyle(fontStyle: FontStyle.normal, color: Colors.white, fontWeight: FontWeight.w700, fontSize: 22, height: 1.2, overflow: TextOverflow.clip),
  );
  static TextStyle styleVolcanicBlue18x600 = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontStyle: FontStyle.normal,
    color: AppKeys().customColors!.volcanicBlue,
    fontWeight: FontWeight.w600,
    fontSize: 18,
  ));

  static TextStyle styleSafeBlue16x600Underline = GoogleFonts.montserrat(
      textStyle: TextStyle(
          fontStyle: FontStyle.normal,
          color: AppKeys().customColors!.safeBlue,
          fontWeight: FontWeight.w600,
          fontSize: 16,
          overflow: TextOverflow.clip,
          decoration: TextDecoration.underline));
}
