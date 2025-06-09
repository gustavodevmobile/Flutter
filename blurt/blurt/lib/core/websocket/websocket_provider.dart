import 'dart:convert';
import 'package:blurt/models/profissional/profissional.dart';
import 'package:blurt/models/profissional/profissional_model.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WebSocketProvider extends ChangeNotifier {
  WebSocketChannel? _channel;
  List<Profissional> profissionaisOnline = [];
  void connect() {
    print('Chamando connect do WebSocketProvider');
    final wsUrl = dotenv.env['WS_URL'];
    print('WS_URL: $wsUrl');
    if (wsUrl != null) {
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      _channel!.stream.listen((message) {
        try {
          final data = jsonDecode(message);
          print('Mensagem recebida: $data');
          if (data is List) {
            profissionaisOnline =
                data.map((e) => ProfissionalModel.fromJson(e)).toList();
            notifyListeners();
          } else if (data is Map && data['type'] == 'status_update') {
            // Atualiza ou adiciona o profissional na lista
            final profissional =
                ProfissionalModel.fromJson(data['profissional']);
            final idx =
                profissionaisOnline.indexWhere((p) => p.id == profissional.id);
            if (idx != -1) {
              profissionaisOnline[idx] = profissional;
            } else {
              profissionaisOnline.add(profissional);
            }
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
    _channel?.sink.close();
    super.dispose();
  }
}
