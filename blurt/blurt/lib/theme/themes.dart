import 'package:flutter/material.dart';

class AppThemes {
  static const Color primaryColor = Color(0xFF4F8FCB);
  static const Color primaryLightColor = Color(0xFFB3D7F2);
  static const Color secondaryColor = Color(0xFF7AB0A3);
  static const Color backgroundColor = Color.fromARGB(255, 117, 177, 163);
  static const Color accentColor = Color(0xFF4F8FCB);
  static const Color errorColor = Colors.red;
  static const Color successColor = Colors.green;
  static const Color warningColor = Colors.amber;
  static const Color textColor = Colors.black87;
  static const Color textLightColor = Colors.white;
  static const Color online = Color.fromARGB(255, 111, 218, 114);
  static const Color offline = Colors.grey;

  static ThemeData get lightTheme => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: secondaryColor,
          primary: primaryColor,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 10,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: textColor),
          bodyMedium: TextStyle(color: textColor),
          bodySmall: TextStyle(color: textColor),
        ),
      );
}
