import 'dart:async';
import 'dart:convert';
import 'package:blurt/models/profissional/profissional.dart';
import 'package:blurt/models/profissional/profissional_model.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WebSocketProvider extends ChangeNotifier {
  WebSocketChannel? channel;
  List<Profissional> profissionaisOnline = [];
  Map<String, Profissional> novaSolicitacaoAtendimentoAvulso = {};
  Timer? _pingTimer;
  Timer? _keepConnectionTimer;
  final wsUrl = dotenv.env['WS_URL'];

  void connect() {
    if (wsUrl != null) {
      channel = WebSocketChannel.connect(Uri.parse(wsUrl!));
      channel!.stream.listen((data) {
        final msg = jsonDecode(data);

        switch (msg['type']) {
          case 'status_update':
            // Atualize a lista de profissionais online
            final profissionais = msg['profissionais'] as List<dynamic>? ?? [];
            profissionaisOnline = profissionais
                .where((e) => e != null && e is Map<String, dynamic>)
                .map((e) =>
                    ProfissionalModel.fromJson(e as Map<String, dynamic>))
                .toList();
            notifyListeners();
            print('Profissionais online atualizados: $profissionaisOnline');

            break;

          case 'nova_solicitacao_atendimento_avulso':
            print('Mensagem de chat: ${msg['textContent']}');
            novaSolicitacaoAtendimentoAvulso = msg['textContent'];
            notifyListeners();
            break;

          default:
            print('Tipo de mensagem desconhecido: $msg');
        }
      }, onError: (error) {
        print('Erro na conexão WebSocket: $error');
      }, onDone: () {
        print('Conexão WebSocket encerrada');
      });
    }
  }

  @override
  void dispose() {
    channel?.sink.close();
    super.dispose();
  }

  void disconnect() {
    channel?.sink.close();
    channel = null;
    profissionaisOnline.clear();
    stopPing();
    stopKeepConnection();
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

  void keepConnection() {
    _keepConnectionTimer?.cancel();
    // Envia ping a cada 14 minutos (o Render hiberna após 15)
    _keepConnectionTimer = Timer.periodic(const Duration(minutes: 10), (timer) {
      final payload = jsonEncode({'type': 'up', 'message': 'Acorda servidor!'});
      channel?.sink.add(payload);
    });
  }

  void stopKeepConnection() {
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

//   {
//   "type": "mensagem_usuario_para_profissional",
//   "usuarioId": "id_do_usuario",
//   "profissionalId": "id_do_profissional",
//   "conteudo": {
//     "texto": "Olá, gostaria de atendimento!"
//     // outros campos, se quiser
//   }
// }
}
