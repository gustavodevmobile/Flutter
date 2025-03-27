import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String error, Color colorMsg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(error),
      duration: const Duration(seconds: 3),
      backgroundColor: colorMsg,
      elevation: 10.0,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
    ),
  );
}
