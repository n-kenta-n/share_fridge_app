import 'package:flutter/material.dart';

// ライトテーマ
ThemeData lightTheme = ThemeData(
  colorScheme: const ColorScheme.light().copyWith(
    surface: Color(0xFFFFFFFF), // 基本の背景色
    onSurface: Colors.black, // テキストの色
    primary: Color(0xFF01AE9A), // progress circleとか
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
  ),
  scaffoldBackgroundColor: Color(0xFFF4F4F4),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      disabledBackgroundColor: Colors.grey,
      disabledForegroundColor: Colors.black,
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
  ),
);

// ダークテーマ
ThemeData darkTheme = ThemeData(
  colorScheme: const ColorScheme.dark().copyWith(
    surface: Color(0xFF232323), // 基本の背景色
    onSurface: Colors.white, // テキストの色
    primary: Color(0xFF0DDDA6), // progress circleとか
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
  ),
  scaffoldBackgroundColor: Color(0xFF303030),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF232323),
      foregroundColor: Colors.white,
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF232323),
    foregroundColor: Colors.white,
  ),
);
