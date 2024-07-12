import 'package:flutter/material.dart';

AppColors currentAppColors = LightThemeAppColors();

abstract class AppColors {
  abstract Color primaryColor;
  abstract Color primaryVariantColor1;
  abstract Color primaryVariantColor2;
  abstract Color primaryVariantColor3;
  abstract Color secondaryColor;
  abstract Color primaryTextColor;
  abstract Color secondaryTextColor;

  // Static colors
  static const Color white = Color(0xffffffff);
  static const Color black = Color(0xFF000000);
  static const Color green = Color(0xff34A346);
  static const Color darkGreen = Color(0xff145c20);
  static const Color lightBlue = Color(0xff50ACFA);
  static const Color mediumBlue = Color(0xff318DDB);
  static const Color darkBlue = Color(0xff16558d);
  static const Color red = Color(0xffea2424);
  static const Color orange = Color(0xffef842c);
  static const Color gold = Color(0xffefab2c);
  static const Color grey = Color(0xff4c4c4c);
  static const Color lightGrey = Color(0xff818181);
  static const Color backGrey = Color(0x74857777);
}

class LightThemeAppColors extends AppColors {
  @override
  Color primaryColor = const Color(0xffffffff);

  @override
  Color primaryTextColor = const Color(0xff000000);

  @override
  Color primaryVariantColor1 = const Color(0xffDEDEDE);

  @override
  Color primaryVariantColor2 = const Color(0xffcfcfcf);

  @override
  Color primaryVariantColor3 = const Color(0xffFBFBFB);

  @override
  Color secondaryColor = const Color(0xff50ACFA);

  @override
  Color secondaryTextColor = const Color(0xff737373);
}

class DarkThemeAppColors extends AppColors {
  @override
  Color primaryColor = const Color(0xff18181B);

  @override
  Color primaryTextColor = const Color(0xffffffff);

  @override
  Color primaryVariantColor1 = const Color(0xff262628);

  @override
  Color primaryVariantColor2 = const Color(0xff323235);

  @override
  Color primaryVariantColor3 = const Color(0xff141417);

  @override
  Color secondaryColor = const Color(0xff318DDB);

  @override
  Color secondaryTextColor = const Color(0xff949496);
}