import 'package:flutter/material.dart';

class GlobalSnackbars {

  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showSnackBar(String message, {Color? backgroundColor}) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(message), backgroundColor: backgroundColor),
    );
  }
}