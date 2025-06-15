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
  Timer? _pingTimer;
  Timer? _keepConnectionTimer;
  Timer? _delayIdentifyConnection;

  void connect() {
    print('Chamando connect do WebSocketProvider');
    final wsUrl = dotenv.env['WS_URL'];
    //print('WS_URL: $wsUrl');
    if (wsUrl != null) {
      channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      channel!.stream.listen((message) {
        try {
          final data = jsonDecode(message);
          for (var prof in data['profissionais']) {
            print(
                'Profissional: ${prof['nome']} - Tipo: ${prof['tipoProfissional']}');
          }
          if (data is List) {
            profissionaisOnline =
                data.map((e) => ProfissionalModel.fromJson(e)).toList();

            notifyListeners();
          } else if (data is Map && data['type'] == 'status_update') {
            // Atualiza ou adiciona o profissional na lista
            final profissionais = data['profissionais'] as List<dynamic>? ?? [];
            profissionaisOnline = profissionais
                .where((e) => e != null && e is Map<String, dynamic>)
                .map((e) =>
                    ProfissionalModel.fromJson(e as Map<String, dynamic>))
                .toList();
            notifyListeners();
          }
        } catch (error) {
          print('Mensagem recebida não é um JSON válido: $error');
        }
      }, onError: (error) {
        print('Erro na conexão WebSocket: $error');
      }, onDone: () {
        print('Conexão WebSocket fechada');
      });
    } else {
      print('API_URL não está definida no arquivo .env $wsUrl');
    }

    // Troca http/https por ws/wss
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
    notifyListeners();
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
  }

  void keepConnection() {
    _keepConnectionTimer?.cancel();
    // Envia ping a cada 14 minutos (o Render hiberna após 15)
    _keepConnectionTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      final payload = jsonEncode({'type': 'up', 'message': 'Acorda servidor!'});
      channel?.sink.add(payload);
    });
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

  void stopKeepConnection() {
    _pingTimer?.cancel();
    _pingTimer = null;
  }
}
