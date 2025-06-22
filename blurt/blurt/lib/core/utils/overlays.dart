import 'dart:convert';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:blurt/core/utils/overlay_float_bubble.dart';
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
  late WebSocketProviderOverlay wsProvider;
  Map<String, dynamic>? dados;

  @override
  void initState() {
    print('Iniciando overlay de solicitações...');
    wsProvider = WebSocketProviderOverlay();
    //wsProvider.connect();
    // if (!wsProvider.isConnected) {
    //   print('Contexto do overlay conectado!');
    //   wsProvider.connect();
    // }
    print('@@@@@@@@@@@@@ Ativo  @@@@@@@@@@@@@@@');
    super.initState();
    // Escuta dados compartilhados
    FlutterOverlayWindow.overlayListener.listen((event) {
      print('Evento recebido no overlay: $event');
      if (event == 'teste') {
        print('@@@@@@@@@@@@ TESTE @@@@@@@@@@@@@@@');
      }

      try {
        final map = event != null ? jsonDecode(event) : null;
        if (map is Map<String, dynamic> && map['type'] != null) {
          switch (map['type']) {
            case 'conectar':
              wsProvider.connect();
              print('wsProvider.connect() chamado no contexto overlay.');
              break;
            case 'start_ping':
              wsProvider.startPing(map['profissionalId']);
              print(
                  'wsProvider.startPing() chamado no contexto overlay: ${map['profissionalId']}');
              break;
            case 'stop_ping':
              wsProvider.stopPing();
              print('wsProvider.stopPing() chamado no contexto overlay.');
              break;
            case 'desconectar':
              wsProvider.disconnect();
              print('wsProvider.disconnect() chamado no contexto overlay.');
              break;
            case 'identificacao_profissional':
              wsProvider.identifyConnection(
                  map['profissionalId'], map['userType']);
              print(
                  ' wsProvider.identifyConnection() chamado no contexto overlay: ${map['profissionalId']}');
              break;
            case 'card':
              setState(() {
                dados = map['conteudo'];
                print('Dados recebidos no overlayListener: $dados');
              });
            case 'teste':
              print('@@@@@@@@@@@@ TESTE @@@@@@@@@@@@@@@');
            // Adicione outros comandos aqui
            default:
              print('Comando desconhecido: ${map['type']}');
          }
        }

        // else {
        //   // Se não for um comando, tente tratar como evento simples
        //   switch (event) {
        //     case 'solicitacao_atendimento_avulso':
        //       wsProvider.solicitarAtendimentoAvulsoOverlay();
        //       break;
        //     // Outros eventos simples...
        //     default:
        //       print('Evento simples desconhecido: $event');
        //   }
        // }
      } catch (e) {
        print('Erro ao processar evento no overlay: $e');
      }
      // switch (event) {
      //   case 'desconectar':
      //     wsProvider.disconnect();
      //     break;
      //   case 'solicitacao_atendimento_avulso':
      //     wsProvider.solicitarAtendimentoAvulsoOverlay();
      //   case 'start_ping':
      //     wsProvider.startPing();
      //   default:
      //     try {
      //       final map = event != null ? jsonDecode(event) : null;
      //       if (map is Map<String, dynamic>) {
      //         setState(() {
      //           dados = map;
      //         });
      //       }
      //     } catch (_) {
      //       print('Erro ao decodificar dados do overlay: $event');
      //     }
      //     break;
      // }
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
        onAceitar: () async {
          AlertaSonoro.parar();
          await FlutterOverlayWindow.closeOverlay();
          const intent = AndroidIntent(
            action: "android.intent.action.MAIN",
            package: 'com.example.blurt', // Substitua pelo seu package name!
            componentName:
                'com.example.blurt/.MainActivity', // Substitua também!
            flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
            arguments: <String, dynamic>{
              'abrir_dashboard': true,
            },
          );
          await intent.launch();
          setState(() {
            dados = null; // Volta para a bolinha
          });
          print('id usuario aceito: $dados');
        },
        onRecusar: () async {
          AlertaSonoro.parar();
          await FlutterOverlayWindow.closeOverlay();
          await Future.delayed(Duration(milliseconds: 300));
          showOverlayFloatBubble();
          setState(() {
            dados = null; // Volta para a bolinha
          });
        },
      );
    }
  }
}
