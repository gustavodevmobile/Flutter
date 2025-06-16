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
  Map<String, Profissional> solicitacaoAtendimento = {};
  Timer? _pingTimer;
  Timer? _keepConnectionTimer;

  void connect() {
    channel = WebSocketChannel.connect(Uri.parse('ws://seu-servidor/ws'));

    channel!.stream.listen((data) {
      final msg = jsonDecode(data);

      switch (msg['type']) {
        case 'status_update':
          // Atualize a lista de profissionais online
          final profissionais = msg['profissionais'] as List<dynamic>? ?? [];
          profissionaisOnline = profissionais
              .where((e) => e != null && e is Map<String, dynamic>)
              .map((e) => ProfissionalModel.fromJson(e as Map<String, dynamic>))
              .toList();
          notifyListeners();
          print('Profissionais online atualizados: $profissionaisOnline');

          break;
        case 'solicitacao_atendimento_avulso':
          print('Mensagem de chat: ${msg['textContent']}');
          solicitacaoAtendimento = msg['textContent'];
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

  // void connect() {
  //   print('Chamando connect do WebSocketProvider');
  //   final wsUrl = dotenv.env['WS_URL'];
  //   //print('WS_URL: $wsUrl');
  //   if (wsUrl != null) {
  //     channel = WebSocketChannel.connect(Uri.parse(wsUrl));
  //     channel!.stream.listen((message) {
  //       try {
  //         final data = jsonDecode(message);
  //         for (var prof in data['profissionais']) {
  //           print(
  //               'Profissional: ${prof['nome']} - Tipo: ${prof['tipoProfissional']}');
  //         }
  //         if (data is List) {
  //           profissionaisOnline =
  //               data.map((e) => ProfissionalModel.fromJson(e)).toList();

  //           notifyListeners();
  //         } else if (data is Map && data['type'] == 'status_update') {
  //           // Atualiza ou adiciona o profissional na lista
  //           final profissionais = data['profissionais'] as List<dynamic>? ?? [];
  //           profissionaisOnline = profissionais
  //               .where((e) => e != null && e is Map<String, dynamic>)
  //               .map((e) =>
  //                   ProfissionalModel.fromJson(e as Map<String, dynamic>))
  //               .toList();
  //           notifyListeners();
  //         }
  //       } catch (error) {
  //         print('Mensagem recebida não é um JSON válido: $error');
  //       }
  //     }, onError: (error) {
  //       print('Erro na conexão WebSocket: $error');
  //     }, onDone: () {
  //       print('Conexão WebSocket fechada');
  //     });
  //   } else {
  //     print('API_URL não está definida no arquivo .env $wsUrl');
  //   }
  //   // Troca http/https por ws/wss
  // }

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

  void solicitarAtendimento(String usuarioId, String profissionalId,
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
