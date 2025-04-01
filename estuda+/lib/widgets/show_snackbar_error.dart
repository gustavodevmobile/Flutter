import 'package:flutter/material.dart';

void showSnackBarError(BuildContext context, String error, Color colorMsg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(error),
      duration: const Duration(seconds: 3),
      backgroundColor: colorMsg,
    ),
  );
}
