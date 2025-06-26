import 'dart:async';
import 'dart:convert';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:blurt/core/utils/overlay_float_bubble.dart';
import 'package:blurt/core/widgets/card_solicitacao_ovelay.dart';
import 'package:blurt/core/widgets/float_bubble.dart';
import 'package:blurt/widgets/pageview_pre_analise.dart';
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
  String? usuarioId;
  String? profissionalId;
  Map<String, dynamic>? usuario;
  Map<String, dynamic>? respostasPreAnalise;

  @override
  void initState() {
    super.initState();
    // Escuta dados compartilhados
    FlutterOverlayWindow.overlayListener.listen((event) {
      try {
        final map = event != null ? jsonDecode(event) : null;
        if (map is Map<String, dynamic>) {
          setState(() {
            profissionalId = map['profissionalId'];
            usuarioId = map['usuarioId'];
            usuario = map['usuario'];
            respostasPreAnalise = map['preAnalise'];
          });
        }
      } catch (_) {
        print('Erro ao decodificar dados do overlay: $event');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (usuario == null) {
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
      RespostasPreAnalise? preAnalise;
      if (respostasPreAnalise != null) {
        // Verifica se as respostas da pré-análise estão disponíveis
        preAnalise = RespostasPreAnalise.fromMap(respostasPreAnalise!);
      }
      AlertaSonoro.tocar(onTimeout: () {
        setState(() {
          usuario = null;
          preAnalise = null;
        });
      });
      return CardSolicitacaoOverlay(
        dadosUsuario: usuario!,
        preAnalise: preAnalise,
        onAceitar: () async {
          AlertaSonoro.parar();
          await FlutterOverlayWindow.closeOverlay();

          final args = <String, dynamic>{
            'abrir_dashboard': true,
            'usuarioId': usuarioId,
            'profissionalId': profissionalId,
            'acao': 'aceitar',
          };

          if (respostasPreAnalise != null) {
            final jsonPreAnalise = jsonEncode(respostasPreAnalise);
            args['preAnalise'] = jsonPreAnalise;
          }

          final intent = AndroidIntent(
            action: 'android.intent.action.MAIN',
            package: 'com.example.blurt',
            componentName: 'com.example.blurt.MainActivity',
            flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
            arguments: args,
          );
          await intent.launch();

          setState(() {
            usuario = null; // Volta para a bolinha
            respostasPreAnalise = null;
          });
        },
        onRecusar: () async {
          AlertaSonoro.parar();
          await FlutterOverlayWindow.closeOverlay();
          await Future.delayed(Duration(milliseconds: 300));
          showOverlayFloatBubble();
          setState(() {
            usuario = null; // Volta para a bolinha
            preAnalise = null;
          });
        },
      );
    }
  }
}
