import 'dart:convert';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:blurt/core/websocket/websocket_provider.dart';
import 'package:blurt/core/websocket/websocket_provider_overlay.dart';
import 'package:blurt/core/widgets/card_solicitacao_ovelay.dart';
import 'package:blurt/core/widgets/float_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import '../utils/alerta_sonoro.dart';

class OverlaySolicitacaoWidget extends StatefulWidget {
  const OverlaySolicitacaoWidget({super.key});

  @override
  State<OverlaySolicitacaoWidget> createState() =>
      _OverlaySolicitacaoWidgetState();
}

class _OverlaySolicitacaoWidgetState extends State<OverlaySolicitacaoWidget> {
  Map<String, dynamic>? dados;
  late WebSocketProviderOverlay wsProvider;

  @override
  void initState() {
    wsProvider = WebSocketProviderOverlay();
    wsProvider.connect();
    super.initState();
    // Escuta dados compartilhados
    FlutterOverlayWindow.overlayListener.listen((event) {
      switch (event) {
        case 'desconectar':
          wsProvider.disconnect();
          break;
        case 'parar_som':
          AlertaSonoro.parar();
          break;
        default:
          try {
            final map = event != null ? jsonDecode(event) : null;
            if (map is Map<String, dynamic>) {
              setState(() {
                dados = map;
              });
            }
          } catch (_) {
            print('Erro ao decodificar dados do overlay: $event');
          }
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (dados == null) {
      return FloatBubble(
        onTap: () async {
          const intent = AndroidIntent(
            action: 'android.intent.action.MAIN',
            package: 'com.example.blurt',
            componentName: 'com.example.blurt.MainActivity',
            flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
            arguments: <String, dynamic>{
              'abrir_dashboard': true,
            },
          );
          await intent.launch();
        },
      );
    } else {
      return CardSolicitacaoOverlay(
        dados: dados!,
        onAceitar: () {
          //AlertaSonoro.parar();
          setState(() {
            dados = null; // Volta para a bolinha
            AlertaSonoro.parar();
          });
        },
        onRecusar: () async {
          AlertaSonoro.parar();
          setState(() {
            dados = null; // Volta para a bolinha
          });
        },
      );
    }
  }
}
