import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class AppLifecycleProvider extends ChangeNotifier with WidgetsBindingObserver {
  bool isInForeground = true;
  bool profissionalLogado = false;
  bool initialized = false;

  AppLifecycleProvider() {
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialized = true;
    });
  }

  @override
  void dispose() {
    FlutterOverlayWindow.closeOverlay();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (initialized) {
      if (state == AppLifecycleState.paused && profissionalLogado) {
        print('App foi para background, executando comandos de overlay');
        isInForeground = false;
        notifyListeners();
      } else if (state == AppLifecycleState.resumed) {
        print('App voltou para o foreground, fechando overlay');
        isInForeground = true;
        notifyListeners();

        //await FlutterOverlayWindow.closeOverlay();
      }
    }
  }
}
