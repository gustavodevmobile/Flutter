import 'package:flutter/material.dart';

void showSnackBarError(BuildContext context, String error, Color colorMsg, {Duration? duration}) {
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(error),
      duration: duration ?? const Duration(seconds: 3),
      backgroundColor: colorMsg,
    ),
  );
}
