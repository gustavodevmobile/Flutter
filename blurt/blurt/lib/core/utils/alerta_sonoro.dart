import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:blurt/core/utils/overlay_float_bubble.dart';
import 'dart:async';

import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class AlertaSonoro {
  static AudioPlayer? _audioPlayer;
  static Timer? _timer;

  static Future<void> tocar({VoidCallback? onTimeout}) async {
    _audioPlayer = AudioPlayer();
    await _audioPlayer!.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer!.play(AssetSource('sounds/alert1.mp3'));
    _timer = Timer(const Duration(minutes: 1), () async {
      parar();
      await FlutterOverlayWindow.closeOverlay();
      await Future.delayed(Duration(milliseconds: 300));
      if (onTimeout != null) onTimeout(); // Chama o callback!
      showOverlayFloatBubble();
      print('Alerta sonoro parado após 1 minuto');
    });
  }

  static void parar() {
    _audioPlayer?.stop();
    _audioPlayer?.dispose();
    _audioPlayer = null;
    _timer?.cancel();
  }
}
