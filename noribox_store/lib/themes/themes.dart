
import 'package:flutter/material.dart';

abstract class Themes {
  static const Color redPrimary = Color(0xFF912A23);
  static const Color redSecondary = Color(0xFFB04A3C);
  static const Color redTertiary = Color(0xFFDA6A5B);
  static const Color greyPrimary = Color(0xFFB6AFA9);
  static const Color greySecondary = Color(0xFFB6AFA9);
  static const Color greyTertiary = Color.fromARGB(255, 214, 208, 202);
  static const Color greyLight = Color(0xFFF8F6F1);
  static const Color blackLight = Color.fromARGB(255, 39, 39, 39);
  static const Color colorBackground = Color(0xFFF8F6F1);
  static const Color white = Color(0xFFFFFFFF);
  static const Color blackShadow = Colors.black12;
  static const Color green = Colors.green;
  static const Color greenLight = Color(0xFFB2E1B2);
  static const Color greenDark = Color.fromARGB(255, 54, 126, 57);
  static const Color error = Colors.red;
}

class ThemesTextStyle {
  static const TextStyle title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Themes.blackLight,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Themes.greyPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: Themes.blackLight,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Themes.white,
  );
}