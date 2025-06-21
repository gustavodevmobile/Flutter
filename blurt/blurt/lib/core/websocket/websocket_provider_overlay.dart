import 'dart:async';
import 'dart:convert';
import 'package:blurt/core/utils/global_snackbars.dart';
import 'package:blurt/core/utils/overlay_card.dart';
import 'package:blurt/models/profissional/profissional.dart';
import 'package:blurt/models/profissional/profissional_model.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WebSocketProviderOverlay extends ChangeNotifier {
  WebSocketChannel? channel;
  List<Profissional> profissionaisOnline = [];
  Map<String, dynamic> novaSolicitacaoAtendimentoAvulso = {};
  Map<String, dynamic> respostaSolicitacaoAtendimentoAvulso = {};
  String? feedback;
  Timer? _pingTimer;

  final wsUrl = dotenv.env['WS_URL'];

  void connect() {
    if (wsUrl != null) {
      channel = WebSocketChannel.connect(Uri.parse(wsUrl!));
      channel!.stream.listen((data) {
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
            //print('Profissionais online atualizados: $profissionaisOnline');
            break;

          case 'nova_solicitacao_atendimento_avulso':

            //novaSolicitacaoAtendimentoAvulso = msg['textContent'];
            //print('Nova solicitação de atendimento avulso: $msg');
            showOverlayCard(msg['conteudo']);

            // GlobalSnackbars.showSnackBar(msg['conteudo']['dataNasciento'],
            //     backgroundColor: Colors.green);
            // notifyListeners();
            break;

          case 'resposta_solicitacao_atendimento_avulso':
            print('Mensagem de chat: ${msg['textContent']}');
            respostaSolicitacaoAtendimentoAvulso = msg['textContent'];
            notifyListeners();
            break;

          case 'feedback_solicitacao_profissional_disponivel':
            print('Mensagem de chat: ${msg['feedback']}');
            GlobalSnackbars.showSnackBar(msg['feedback'],
                backgroundColor: Colors.green);
            // notifyListeners();
            break;

          case 'feedback_solicitacao_profissional_indisponivel':
            print('Mensagem de chat: ${msg['feedback']}');
            GlobalSnackbars.showSnackBar(msg['feedback'],
                backgroundColor: Colors.red);
            break;

          default:
            print('Tipo de mensagem desconhecido: $msg');
        }
      }, onError: (error) {
        print('Erro na conexão WebSocket: $error');
      }, onDone: () {
        print('Conexão WebSocket ');
      });
    }
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }

  void disconnect() {
    channel?.sink.close();
    channel = null;
    profissionaisOnline.clear();
    stopPing();
    print('Conexão WebSocket desconectada');
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
      Map<String, dynamic> textContent) {
    try {
      final payload = jsonEncode({
        'type': 'solicitacao_atendimento_avulso',
        'usuarioId': usuarioId,
        'profissionalId': profissionalId,
        'conteudo': textContent
      });
      channel?.sink.add(payload);
      print('Requisitando serviços: $payload');
    } catch (e) {
      print('Erro ao requisitar serviços: $e');
    }
  }

  void respostaAtendimentoAvulso(String usuarioId, String profissionalId,
      Map<String, dynamic> textContent) {
    try {
      final payload = jsonEncode({
        'type': 'solicitacao_atendimento_avulso',
        'usuarioId': usuarioId,
        'profissionalId': profissionalId,
        'conteudo': textContent
      });
      channel?.sink.add(payload);
      print('Requisitando serviços: $payload');
    } catch (e) {
      print('Erro ao requisitar serviços: $e');
    }
  }
}
