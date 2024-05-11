import 'package:flutter/material.dart';
import 'package:flutter_football/config/app_colors.dart';

final lightTheme = ThemeData(
  useMaterial3: true,

  // sets the background color of the `BottomNavigationBar`
  //canvasColor: LightThemeAppColors().primaryColor,
  // sets the active color of the `BottomNavigationBar` if `Brightness` is light
  //primaryColor: LightThemeAppColors().secondaryColor,

  brightness: Brightness.light,
  primarySwatch: Colors.blue,

  colorScheme: ColorScheme.fromSeed(
    background: LightThemeAppColors().primaryColor,
    seedColor: LightThemeAppColors().primaryColor,
    brightness: Brightness.light,
  ),

  /*textTheme: TextTheme(
      bodySmall: TextStyle(color: Colors.yellow)
    ),*/
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

  /*textTheme: TextTheme(
      displayLarge: const TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: GoogleFonts.oswald(
        fontSize: 30,
        fontStyle: FontStyle.italic,
      ),
      bodyMedium: GoogleFonts.merriweather(),
      displaySmall: GoogleFonts.pacifico(),
    ),*/
);
