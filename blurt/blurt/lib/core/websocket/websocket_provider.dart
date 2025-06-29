import 'dart:async';
import 'dart:convert';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:blurt/core/utils/global_snackbars.dart';
import 'package:blurt/core/utils/overlay_card.dart';
import 'package:blurt/core/utils/overlay_solicitacao.dart';
import 'package:blurt/core/widgets/card_feedback_overlay.dart';

import 'package:blurt/main.dart';
import 'package:blurt/models/profissional/profissional.dart';
import 'package:blurt/models/profissional/profissional_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WebSocketProvider extends ChangeNotifier {
  WebSocketChannel? channel;
  List<Profissional> profissionaisOnline = [];
  Map<String, dynamic> novaSolicitacaoAtendimentoAvulso = {};
  //Map<String, dynamic> respostaSolicitacaoAtendimentoAvulso = {};
  //String? feedback;
  Timer? _pingTimer;
  bool novaSolicitacao = false;

  final wsUrl = dotenv.env['WS_URL'];
  final StreamController _eventoSolicitacaoController =
      StreamController.broadcast();
  Stream get streamSolicitacao => _eventoSolicitacaoController.stream;

  void setNovaSolicitacao(
      String tipoAtendimento, Map<String, dynamic> dadosUsuario,
      {Map<String, dynamic>? preAnalise}) {
    novaSolicitacao = true;
    novaSolicitacaoAtendimentoAvulso = {
      'tipoAtendimento': tipoAtendimento,
      'dadosUsuario': dadosUsuario,
      'preAnalise': preAnalise,
    };
    notifyListeners();
  }

  void connect() {
    if (wsUrl != null) {
      channel = WebSocketChannel.connect(Uri.parse(wsUrl!));
      channel!.stream.listen((data) async {
        final msg = jsonDecode(data);

        switch (msg['type']) {
          case 'status_update':
            final profissionais = msg['profissionais'] as List<dynamic>? ?? [];
            profissionaisOnline = profissionais
                .where((e) => e != null && e is Map<String, dynamic>)
                .map((e) =>
                    ProfissionalModel.fromJson(e as Map<String, dynamic>))
                .toList();
            notifyListeners();
            break;
          case 'nova_solicitacao_atendimento_avulso':
            print('Nova solicitação de atendimento avulso recebida');
            if (await FlutterOverlayWindow.isPermissionGranted()) {
              if (!appLifecycleProvider.isInForeground) {
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
                await Future.delayed(const Duration(milliseconds: 500));
                if (msg['preAnalise'] != null) {
                  // solicitacaoAtendimento('atendimento_avulso', msg['usuarioId'],
                  //     msg['profissionalId'], msg['usuario'],
                  //     preAnalise: msg['preAnalise']);
                  _eventoSolicitacaoController
                      .add(novaSolicitacaoAtendimentoAvulso = {
                    'tipoAtendimento': 'atendimento_avulso',
                    'dadosUsuario': msg['usuario'],
                    'preAnalise': msg['preAnalise'],
                  });
                  break;
                } else {
                  // solicitacaoAtendimento('atendimento_avulso', msg['usuarioId'],
                  //     msg['profissionalId'], msg['usuario']);
                  _eventoSolicitacaoController
                      .add(novaSolicitacaoAtendimentoAvulso = {
                    'tipoAtendimento': 'atendimento_avulso',
                    'dadosUsuario': msg['usuario'],
                  });
                  break;
                }
              } else {
                if (msg['preAnalise'] != null) {
                  // solicitacaoAtendimento('atendimento_avulso', msg['usuarioId'],
                  //     msg['profissionalId'], msg['usuario'],
                  //     preAnalise: msg['preAnalise']);
                  _eventoSolicitacaoController
                      .add(novaSolicitacaoAtendimentoAvulso = {
                    'tipoAtendimento': 'atendimento_avulso',
                    'dadosUsuario': msg['usuario'],
                    'preAnalise': msg['preAnalise'],
                  });
                  break;
                } else {
                  // solicitacaoAtendimento('atendimento_avulso', msg['usuarioId'],
                  //     msg['profissionalId'], msg['usuario']);
                  _eventoSolicitacaoController
                      .add(novaSolicitacaoAtendimentoAvulso = {
                    'tipoAtendimento': 'atendimento_avulso',
                    'dadosUsuario': msg['usuario'],
                  });
                  break;
                }
              }
            }
          case 'resposta_solicitacao_atendimento_avulso':
            print('Resposta de solicitação de atendimento avulso recebida');
            if (msg['mensagem'] != null) {
              closeCentralOverlay();
              navigatorKey.currentState
                  ?.popAndPushNamed('/perfil_profissional');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showCentralOverlay(
                  CardFeedbackSolicitacaoWidget(
                    estado: 'aceita',
                    mensagem: 'teste',
                    linkSala: 'http://teste.com', // se aplicável
                    onTimeout: () {
                      // Implementar lógica de timeout, se necessário
                      closeCentralOverlay();
                    },
                    onClose: () {
                      closeCentralOverlay();
                    },
                  ),
                );
              });
            }

            // GlobalSnackbars.showSnackBar(msg['mensagem'],
            //     backgroundColor: Colors.green);
            break;
          case 'feedback_solicitacao_profissional_disponivel':
            print(
                'Feedback de solicitação de profissional disponível recebido');
            // navigatorKey.currentState?.pop();
            navigatorKey.currentState?.popAndPushNamed('/perfil_profissional');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showCentralOverlay(
                CardFeedbackSolicitacaoWidget(
                  estado: 'aguardando',
                  mensagem: 'teste',
                  linkSala: 'http://teste.com', // se aplicável
                  onTimeout: () {
                    // Implementar lógica de timeout, se necessário
                    closeCentralOverlay();
                  },
                  onClose: () {
                    closeCentralOverlay();
                  },
                ),
              );
            });

            break;
          case 'feedback_solicitacao_profissional_indisponivel':
            print('Mensagem de chat: ${msg['feedback']}');

            GlobalSnackbars.showSnackBar(msg['feedback'],
                backgroundColor: Colors.red);
            break;
          case 'nova_solicitacao_atendimento_imediato':
            print('Nova solicitação de atendimento imediato recebida');
            if (await FlutterOverlayWindow.isPermissionGranted()) {
              if (!appLifecycleProvider.isInForeground) {
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
                await Future.delayed(const Duration(milliseconds: 500));
                solicitacaoAtendimento('atendimento_imediato', msg['usuarioId'],
                    msg['profissionalId'], msg['usuario']);
              } else {
                solicitacaoAtendimento('atendimento_imediato', msg['usuarioId'],
                    msg['profissionalId'], msg['usuario']);
              }
            }
            break;
          default:
            print('Tipo de mensagem desconhecido: $msg');
        }
      }, onError: (error) {
        print('Erro na conexão WebSocket: $error');
      }, onDone: () {
        print('Conexão WebSocket app principal desconectada');
      });
    }
  }

  void disconnect() {
    channel?.sink.close();
    channel = null;
    profissionaisOnline.clear();
    stopPing();
    //print('Conexão WebSocket desconectada');
  }

  void setProfissionaisOnline(List<Profissional> lista) {
    profissionaisOnline = List.from(lista);
    notifyListeners();
  }

  void startPing(String profissionalId) {
    try {
      _pingTimer?.cancel();
      final payload =
          jsonEncode({'type': 'ping', 'profissionalId': profissionalId});
      channel?.sink.add(payload);
      _pingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
        channel?.sink.add(payload);
      });
    } catch (e) {
      print('Erro ao iniciar o ping: $e');
    }
  }

  void stopPing() {
    _pingTimer?.cancel();
    _pingTimer = null;
  }

  void identifyConnection(String id, String userType) {
    try {
      final payload = jsonEncode({
        "type": "identificacao",
        "userType": userType,
        "id": id,
      });

      channel?.sink.add(payload);

      print('Identificando conexão: $payload');
    } catch (e) {
      print('Erro ao identificar conexão: $e');
    }
  }

  void solicitarAtendimentoAvulso(String usuarioId, String profissionalId,
      Map<String, dynamic> dadosUsuario,
      {Map<String, dynamic>? preAnalise}) {
    try {
      final payload = jsonEncode({
        'type': 'solicitacao_atendimento_avulso',
        'usuarioId': usuarioId,
        'profissionalId': profissionalId,
        'dadosUsuario': dadosUsuario,
        'preAnalise': preAnalise
      });
      print('Payload de solicitação: $payload');
      channel?.sink.add(payload);
      print('Requisitando serviços: $payload');
    } catch (e) {
      print('Erro ao requisitar serviços: $e');
    }
  }

  void respostaAtendimentoAvulso(String usuarioId, String profissionalId,
      {Map<String, dynamic>? respostasPreAnalise}) {
    try {
      final payload = jsonEncode({
        'type': 'resposta_atendimento_avulso',
        'usuarioId': usuarioId,
        'profissionalId': profissionalId,
        'respostasPreAnalise': respostasPreAnalise ?? {}
      });

      channel?.sink.add(payload);
      //print('Resposta atendimento avulso: $payload');
    } catch (e) {
      print('Erro ao requisitar serviços: $e');
    }
  }

  void solicitacaoAtendimentoImediato(
      String usuarioId, String genero, Map<String, dynamic> dadosUsuario) {
    try {
      final payload = jsonEncode({
        'type': 'solicitacao_atendimento_imediato',
        'usuarioId': usuarioId,
        'genero': genero,
        'dadosUsuario': dadosUsuario
      });
      channel?.sink.add(payload);
      print('Requisitando atendimento imediato: $payload');
    } catch (e) {
      print('Erro ao requisitar serviços: $e');
    }
  }

  void respostaAtendimentoImediato(
    String usuarioId,
    String profissionalId,
    bool aceito,
    bool recusado,
  ) {
    try {
      final payload = jsonEncode({
        'type': 'resposta_atendimento_imediato',
        'usuarioId': usuarioId,
        'profissionalId': profissionalId,
        'aceito': aceito,
        'recusado': recusado,
      });
      channel?.sink.add(payload);
      //print('Resposta atendimento imediato: $payload');
    } catch (e) {
      print('Erro ao responder solicitação de atendimento imediato: $e');
    }
  }
}
