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
  Map<String, dynamic>? usuario;
  RespostasPreAnalise? preAnalise;

  @override
  void initState() {
    super.initState();
    // Escuta dados compartilhados
    FlutterOverlayWindow.overlayListener.listen((event) {
      try {
        final map = event != null ? jsonDecode(event) : null;
        if (map is Map<String, dynamic>) {
          setState(() {
            usuario = map['usuario'] as Map<String, dynamic>?;
            preAnalise = map['preAnalise'] as RespostasPreAnalise?;
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
      AlertaSonoro.tocar();
      return CardSolicitacaoOverlay(
        dadosUsuario: usuario!,
        preAnalise: preAnalise,
        onAceitar: () async {
          // print(dados);
          AlertaSonoro.parar();
          await FlutterOverlayWindow.closeOverlay();
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
          //await FlutterOverlayWindow.closeOverlay();
          setState(() {
            usuario = null; // Volta para a bolinha
            preAnalise = null;
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

      //       Positioned(
      //         left: position.dx,
      //         top: position.dy,
      //         child: Draggable<String>(
      //           data: 'bubble',
      //           feedback: FloatBubble(
      //             onTap: () async {
      //               const intent = AndroidIntent(
      //                 action: 'android.intent.action.MAIN',
      //                 package: 'com.example.blurt',
      //                 componentName: 'com.example.blurt.MainActivity',
      //                 flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      //                 arguments: <String, dynamic>{
      //                   'abrir_dashboard': true,
      //                 },
      //               );

      //               await intent.launch();
      //             },
      //           ),
      //           childWhenDragging: Container(),
      //           child: FloatBubble(
      //             onTap: () async {
      //               const intent = AndroidIntent(
      //                 action: 'android.intent.action.MAIN',
      //                 package: 'com.example.blurt',
      //                 componentName: 'com.example.blurt.MainActivity',
      //                 flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      //                 arguments: <String, dynamic>{
      //                   'abrir_dashboard': true,
      //                 },
      //               );

      //               await intent.launch();
      //             },
      //           ),
      //           onDragEnd: (details) {
      //             setState(() {
      //               position = details.offset;
      //             });
      //           },
      //         ),
      //       )
      //     ],
      //   ),
      // );
