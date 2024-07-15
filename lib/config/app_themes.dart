import 'package:flutter/material.dart';
import 'package:flutter_football/config/app_colors.dart';

class AppTextStyle {

  static TextStyle title = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: currentAppColors.primaryTextColor,
  );

  static TextStyle subtitle1 = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  );

  static TextStyle subtitle2 = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
  );

  static TextStyle regular = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
  );

  static TextStyle small = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
  );

}

final lightTheme = ThemeData(
  useMaterial3: true,

  brightness: Brightness.light,
  primarySwatch: Colors.blue,

  colorScheme: ColorScheme.fromSeed(
    background: LightThemeAppColors().primaryColor,
    seedColor: LightThemeAppColors().primaryColor,
    brightness: Brightness.light,
  ),
);

final darkTheme = ThemeData(
  useMaterial3: true,
  primaryColor: DarkThemeAppColors().primaryColor,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    background: DarkThemeAppColors().primaryColor,
    seedColor: DarkThemeAppColors().primaryColor,
    brightness: Brightness.dark,
  ),
);

final darkTheme2 = ThemeData(
  useMaterial3: true,
  // Define the default brightness and colors.
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.purple,
    brightness: Brightness.dark,
  ),
);
