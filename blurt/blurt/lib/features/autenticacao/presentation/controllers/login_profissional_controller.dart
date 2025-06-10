import 'dart:async';
import 'dart:convert';

import 'package:blurt/models/profissional/profissional.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../domain/usecases/login_profissional_usecase.dart';

class LoginProfissionalController extends ChangeNotifier {
  final LoginProfissionalUseCase loginUseCase;
  //final WebSocketChannel channel; // Adicione isso
  LoginProfissionalController(this.loginUseCase);

  Profissional? profissional;

  Future<Profissional?> login(String cpf, String senha) async {
    try {
      profissional = await loginUseCase(cpf, senha);
      // if (profissional != null) {
      //   startPing(profissional!.id!, channel);
      // }
      return profissional;
    } catch (e) {
      print('Erro ao fazer login: $e');
      rethrow;
    }
  }

  Timer? _pingTimer;

  void startPing(String profissionalId,  WebSocketChannel channel) {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      final payload =
          jsonEncode({'type': 'ping', 'profissionalId': profissionalId});
      print('Enviando ping: $payload'); // ADICIONE ISSO
      channel.sink.add(payload);
    });
  }

  void stopPing() {
    _pingTimer?.cancel();
  }
}
