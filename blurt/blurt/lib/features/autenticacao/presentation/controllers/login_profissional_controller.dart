import 'dart:async';
import 'dart:convert';
import 'package:blurt/core/websocket/websocket_provider.dart';
import 'package:blurt/models/profissional/profissional.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/usecases/login_profissional_usecase.dart';

class LoginProfissionalController extends ChangeNotifier {
  final LoginProfissionalUseCase loginUseCase;
  LoginProfissionalController(this.loginUseCase);

  Profissional? profissional;
  MemoryImage? fotoDecodificada;

  Future<Profissional?> login(
      String cpf, String senha, BuildContext context) async {
    try {
      profissional = await loginUseCase(cpf, senha);

      return profissional;
    } catch (e) {
      print('Erro ao fazer login: $e');
      rethrow;
    }
  }
}
