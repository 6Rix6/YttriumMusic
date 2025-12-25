import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  useMaterial3: true,
  sliderTheme: SliderThemeData(year2023: false),
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: Colors.grey.shade900,
    onPrimary: Colors.white,
    secondary: Colors.grey.shade400,
    onSecondary: Colors.white,
    error: Colors.redAccent,
    onError: Colors.limeAccent,
    surface: Colors.grey.shade200,
    onSurface: Colors.black,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.grey.shade900,
    foregroundColor: Colors.white,
  ),
  shadowColor: Colors.grey.shade400,
  scaffoldBackgroundColor: Colors.grey.shade200,
  cardColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey.shade200,
    foregroundColor: Colors.black,
  ),
);

final darkTheme = ThemeData(
  useMaterial3: true,
  sliderTheme: SliderThemeData(year2023: false),
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: Colors.grey.shade200,
    onPrimary: Colors.grey.shade900,
    secondary: Colors.grey.shade700,
    onSecondary: Colors.white,
    error: Colors.redAccent,
    onError: Colors.limeAccent,
    surface: Colors.grey.shade900,
    onSurface: Colors.white,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.grey.shade200,
    foregroundColor: Colors.black,
  ),
  scaffoldBackgroundColor: Colors.black,
  cardColor: Colors.grey.shade900,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
  ),
);
