import 'package:flutter/material.dart';

class AppLifecycleProvider extends ChangeNotifier with WidgetsBindingObserver {
  bool isInForeground = true;

  AppLifecycleProvider() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    isInForeground = state == AppLifecycleState.resumed;
    print('Primeiro plano: $isInForeground');
    notifyListeners();
  }
}