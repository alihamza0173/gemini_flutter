import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.blue,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
      primary: Colors.blue,
      secondary: Colors.blue,
    ),
  );
}
