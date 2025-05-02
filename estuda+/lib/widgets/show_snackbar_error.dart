import 'package:estudamais/theme/app_theme.dart';
import 'package:flutter/material.dart';

void showSnackBarFeedback(BuildContext context, String error, Color colorMsg, {Duration? duration}) {
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(error,style: AppTheme.customTextStyle2(),),
      duration: duration ?? const Duration(seconds: 2),
      backgroundColor: colorMsg,
    ),
  );
}
