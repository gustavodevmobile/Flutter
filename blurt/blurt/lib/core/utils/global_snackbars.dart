import 'package:flutter/material.dart';

class GlobalSnackbars {

  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showSnackBar(String message, {Color? backgroundColor, int durationInSeconds = 3}) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(message), backgroundColor: backgroundColor, duration: Duration(seconds: durationInSeconds),),
    );
  }
}