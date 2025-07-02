import 'dart:async';
import 'dart:convert';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';

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
  Timer? _pingTimer;

  final wsUrl = dotenv.env['WS_URL'];
  final StreamController _eventoSolicitacaoController =
      StreamController.broadcast();
  Stream get streamSolicitacao => _eventoSolicitacaoController.stream;

  void connect() {
    if (wsUrl != null) {
      channel = WebSocketChannel.connect(Uri.parse(wsUrl!));
      channel!.stream.listen((data) async {
        final msg = jsonDecode(data);
        print('Mensagem recebida no Websocket: $msg');
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
          // Dashboard Profissional
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
                _eventoSolicitacaoController
                    .add(novaSolicitacaoAtendimentoAvulso = {
                  'eventType': 'nova_solicitacao_atendimento_imediato',
                  'valorConsulta': msg['valorConsulta'],
                  'usuarioId': msg['usuarioId'],
                  'profissionalId': msg['profissionalId'],
                  'tipoAtendimento': 'atendimento_imediato',
                  'dadosUsuario': msg['usuario'],
                });
              } else {
                _eventoSolicitacaoController
                    .add(novaSolicitacaoAtendimentoAvulso = {
                  'usuarioId': msg['usuarioId'],
                  'profissionalId': msg['profissionalId'],
                  'tipoAtendimento': 'atendimento_imediato',
                  'dadosUsuario': msg['usuario'],
                });
              }
            }
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
                await Future.delayed(const Duration(milliseconds: 300));
                if (msg['preAnalise'] != null) {
                  _eventoSolicitacaoController
                      .add(novaSolicitacaoAtendimentoAvulso = {
                    'eventType': 'nova_solicitacao_atendimento_avulso',
                    'valorConsulta': msg['valorConsulta'],
                    'usuarioId': msg['usuarioId'],
                    'profissionalId': msg['profissionalId'],
                    'tipoAtendimento': 'atendimento_avulso',
                    'dadosUsuario': msg['usuario'],
                    'preAnalise': msg['preAnalise'],
                  });
                  break;
                } else {
                  _eventoSolicitacaoController
                      .add(novaSolicitacaoAtendimentoAvulso = {
                    'eventType': 'nova_solicitacao_atendimento_avulso',
                    'usuarioId': msg['usuarioId'],
                    'profissionalId': msg['profissionalId'],
                    'tipoAtendimento': 'atendimento_avulso',
                    'dadosUsuario': msg['usuario'],
                  });
                  break;
                }
              } else {
                if (msg['preAnalise'] != null) {
                  _eventoSolicitacaoController
                      .add(novaSolicitacaoAtendimentoAvulso = {
                    'eventType': 'nova_solicitacao_atendimento_avulso',
                    'usuarioId': msg['usuarioId'],
                    'profissionalId': msg['profissionalId'],
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
                    'eventType': 'nova_solicitacao_atendimento_avulso',
                    'usuarioId': msg['usuarioId'],
                    'profissionalId': msg['profissionalId'],
                    'tipoAtendimento': 'atendimento_avulso',
                    'dadosUsuario': msg['usuario'],
                  });
                  break;
                }
              }
            }

          // Dashboard Usuário
          case 'buscando_profissionais':
            print('Buscando profissionais disponíveis...');
            _eventoSolicitacaoController
                .add(novaSolicitacaoAtendimentoAvulso = {
              'eventType': 'buscando_profissionais',
              'estado': 'aguardando_profissionais_disponiveis',
              'mensagem': msg['mensagem'],
            });
            break;
          case 'resposta_solicitacao_atendimento_imediato':
            print('Profissional encontrado: ${msg['profissionalId']}');
            _eventoSolicitacaoController
                .add(novaSolicitacaoAtendimentoAvulso = {
              'eventType': 'resposta_solicitacao_atendimento_imediato',
              'profissionalId': msg['profissionalId'],
              'dadosProfissional': msg['dadosProfissional'],
              'mensagem': msg['mensagem'],
            });
            break;

          //Perfil Profissional
          case 'resposta_solicitacao_atendimento_avulso':
            print('Resposta de solicitação de atendimento avulso recebida');
            if (msg['aceita']) {
              _eventoSolicitacaoController
                  .add(novaSolicitacaoAtendimentoAvulso = {
                'eventType': 'resposta_solicitacao_atendimento_avulso',
                'tipoAtendimento': 'atendimento_avulso',
                'usuarioId': msg['usuarioId'],
                'profissionalId': msg['profissionalId'],
                'aceita': true,
                'mensagem': msg['mensagem'],
              });
            } else if (!msg['aceita']) {
              _eventoSolicitacaoController
                  .add(novaSolicitacaoAtendimentoAvulso = {
                'eventType': 'resposta_solicitacao_atendimento_avulso',
                'tipoAtendimento': 'atendimento_avulso',
                'usuarioId': msg['usuarioId'],
                'profissionalId': msg['profissionalId'],
                'aceita': false,
                'mensagem': msg['mensagem'],
              });
            }
            break;
          case 'feedback_solicitacao_profissional_disponivel':
            if (msg['feedback'] != null) {
              _eventoSolicitacaoController
                  .add(novaSolicitacaoAtendimentoAvulso = {
                'eventType': 'feedback_solicitacao_profissional_disponivel',
                'usuarioId': msg['usuarioId'],
                'profissionalId': msg['profissionalId'],
                'estado': 'aguardando',
                'feedback': msg['feedback'],
              });
            }

            break;

          // Dashboard Usuário e Perfil Profissional
          case 'feedback_solicitacao_profissional_indisponivel':
            _eventoSolicitacaoController
                .add(novaSolicitacaoAtendimentoAvulso = {
              'eventType': 'feedback_solicitacao_profissional_indisponivel',
              'mensagem': msg['mensagem'],
            });
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

  void respostaAtendimentoAvulso(
      String usuarioId, String profissionalId, bool aceita,
      {Map<String, dynamic>? respostasPreAnalise}) {
    try {
      final payload = jsonEncode({
        'type': 'resposta_atendimento_avulso',
        'aceita': aceita,
        'usuarioId': usuarioId,
        'profissionalId': profissionalId,
        'respostasPreAnalise': respostasPreAnalise ?? {}
      });
      print('Payload de resposta: $payload');
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
  ) {
    try {
      final payload = jsonEncode({
        'type': 'resposta_atendimento_imediato',
        'usuarioId': usuarioId,
        'profissionalId': profissionalId,
        'aceito': aceito,
      });
      channel?.sink.add(payload);
      //print('Resposta atendimento imediato: $payload');
    } catch (e) {
      print('Erro ao responder solicitação de atendimento imediato: $e');
    }
  }
}
