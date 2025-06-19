import 'package:blurt/core/utils/overlay_float_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class AppLifecycleProvider extends ChangeNotifier with WidgetsBindingObserver {
  bool isInForeground = true;

  AppLifecycleProvider() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    FlutterOverlayWindow.closeOverlay();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      // App foi para background
      isInForeground = false;
      notifyListeners();
      showOverlayFloatBubble();
    } else if (state == AppLifecycleState.resumed) {
      // App voltou para foreground
      isInForeground = true;
      notifyListeners();

      // Fecha o overlay se estiver aberto
      await FlutterOverlayWindow.closeOverlay();
    }
  }
}
