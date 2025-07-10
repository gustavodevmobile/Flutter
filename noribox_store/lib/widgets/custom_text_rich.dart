import 'package:flutter/material.dart';

class CustomTextRich extends StatelessWidget {
  final String textPrimary;
  final String? textSecondary;
  final String? textTertiary;
  final String? textQuaternary;
  final String? textQuinary;
  final Color? colorTextPrimary;
  final Color? colorTextSecondary;
  final Color? colorTextTertiary;
  final Color? colorTextQuaternary;
  final Color? colorTextQuinary;
  final double? fontSizePrimary;
  final double? fontSizeSecondary;
  final double? fontSizeTertiary;
  final double? fontSizeQuaternary;
  final double? fontSizeQuinary;
  final bool isBoldPrimary;
  final bool isBoldSecondary;
  final bool isBoldTertiary;
  final bool isBoldQuaternary;
  final bool isBoldQuinary;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextStyle? style;

  const CustomTextRich({
    super.key,
    required this.textPrimary,
    this.textSecondary,
    this.textTertiary,
    this.textQuaternary,
    this.textQuinary,
    this.colorTextPrimary,
    this.colorTextSecondary,
    this.colorTextTertiary,
    this.colorTextQuaternary,
    this.colorTextQuinary,
    this.fontSizePrimary,
    this.fontSizeSecondary,
    this.fontSizeTertiary,
    this.fontSizeQuaternary,
    this.fontSizeQuinary,
    this.isBoldPrimary = false,
    this.isBoldSecondary = false,
    this.isBoldTertiary = false,
    this.isBoldQuaternary = false,
    this.isBoldQuinary = false,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: textPrimary,
            style: TextStyle(
              fontSize: fontSizePrimary ?? 16.0,
              color: colorTextPrimary ?? Colors.black,
              fontWeight: isBoldPrimary ? FontWeight.bold : FontWeight.normal,
            )
          ),
          if (textSecondary != null)
            TextSpan(
              text: ' $textSecondary',
              style: TextStyle(
                fontWeight: isBoldSecondary ? FontWeight.bold : FontWeight.normal,  
                color: colorTextSecondary ?? Colors.grey,
                fontSize: fontSizeSecondary ?? 14.0,
              )
            ),
            if(textTertiary != null)
            TextSpan(
              text: ' $textTertiary',
              style: TextStyle(
                fontWeight: isBoldTertiary ? FontWeight.bold : FontWeight.normal,  
                color: colorTextTertiary ?? Colors.grey,
                fontSize: fontSizeTertiary ?? 14.0,
              )
            ),
          if (textQuaternary != null)
            TextSpan(
              text: ' $textQuaternary',
              style: TextStyle(
                fontWeight: isBoldQuaternary ? FontWeight.bold : FontWeight.normal,  
                color: colorTextQuaternary ?? Colors.grey,
                fontSize: fontSizeQuaternary ?? 14.0,
              )
            ),
          if (textQuinary != null)
            TextSpan(
              text: ' $textQuinary',
              style: TextStyle(
                fontWeight: isBoldQuinary ? FontWeight.bold : FontWeight.normal,  
                color: colorTextQuinary ?? Colors.grey,
                fontSize: fontSizeQuinary ?? 14.0,
              )
            ),
        ],
        style: style,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
