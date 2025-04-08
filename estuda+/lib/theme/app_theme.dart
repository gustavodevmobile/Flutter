import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTheme {
// Define o estilo padrão dos textos
  static TextStyle customTextStyle(
      {double? fontSize,
      Color? color,
      bool underline = false,
      bool fontWeight = false}) {
    return GoogleFonts.aboreto(
      fontSize: fontSize ?? 15,
      fontWeight: fontWeight ? FontWeight.bold : FontWeight.normal,
      color: color ?? Colors.white,
      decoration: underline ? TextDecoration.underline : TextDecoration.none,
    );
  }

  static TextStyle customTextStyle2(
      {double? fontSize, Color? color, bool underline = false}) {
    return GoogleFonts.exo2(
      fontSize: fontSize ?? 15,
      fontWeight: FontWeight.bold,
      color: color ?? Colors.white,
      decoration: underline ? TextDecoration.underline : TextDecoration.none,
    );
  }
}
