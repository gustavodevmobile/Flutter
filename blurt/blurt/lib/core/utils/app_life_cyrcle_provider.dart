import 'dart:convert';

import 'package:blurt/core/utils/overlay_float_bubble.dart';
import 'package:blurt/core/websocket/websocket_provider.dart';
import 'package:blurt/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:provider/provider.dart';

class AppLifecycleProvider extends ChangeNotifier with WidgetsBindingObserver {
  bool isInForeground = true;
  bool profissionalLogado = false;
  bool initialized = false;
  String? profissionalId;

  AppLifecycleProvider() {
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialized = true;
    });
  }

  void setProfissionalId(String id) {
    profissionalId = id;
    notifyListeners();
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
        isInForeground = false;
        notifyListeners();
        WebSocketProvider? wsProvider = Provider.of<WebSocketProvider>(
          navigatorKey.currentContext!,
          listen: false,
        );
        // desconecta do contexto principal
        wsProvider.disconnect();
        // App foi para background
        await Future.delayed(const Duration(milliseconds: 300));
       showOverlayFloatBubble();
        await Future.delayed(const Duration(milliseconds: 300));
        await FlutterOverlayWindow.shareData(jsonEncode({
          'type': 'conectar',
        }));
        await Future.delayed(const Duration(milliseconds: 300));

        await Future.delayed(const Duration(milliseconds: 300));
        // reinicia o ping do profissional no contexto overlay
        if (profissionalId != null) {
          await FlutterOverlayWindow.shareData(jsonEncode({
            'type': 'start_ping',
            'profissionalId': profissionalId,
          }));
        }

        if (profissionalId != null) {
          await FlutterOverlayWindow.shareData(jsonEncode({
            'type': 'identificacao_profissional',
            'profissionalId': profissionalId,
            'userType': 'profissional',
          }));

          await FlutterOverlayWindow.shareData(jsonEncode({
            'type': 'start_ping',
            'profissionalId': profissionalId,
            
          }));
        }

        // Exibe o overlay de bolha flutuante

        print('App foi para background');
      } else if (state == AppLifecycleState.resumed) {
        await FlutterOverlayWindow.shareData(jsonEncode({
          'type': 'desconectar',
        }));
        // App voltou para foreground
        isInForeground = true;
        notifyListeners();
        // Reconnecta ao WebSocket no contexto principal

        WebSocketProvider? wsProvider = Provider.of<WebSocketProvider>(
          navigatorKey.currentContext!,
          listen: false,
        );
        Future.delayed(const Duration(milliseconds: 300));
        wsProvider.connect();

        // Reconecta o ping do profissional ao contexto principal
        if (profissionalId != null) {
          wsProvider.startPing(profissionalId!);
          wsProvider.identifyConnection(
            profissionalId!,
            'profissional',
          );
        }
        print('App voltou para foreground');
        // Fecha o overlay se estiver aberto
        await FlutterOverlayWindow.closeOverlay();
      }
    }
  }
}
