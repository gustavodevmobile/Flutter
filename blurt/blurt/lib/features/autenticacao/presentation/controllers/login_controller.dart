import 'package:flutter/material.dart';
import '../../domain/usecases/login_usuario_usecase.dart';
import '../../../../models/usuario/usuario.dart';

class LoginUsuarioController extends ChangeNotifier {
  final LoginUsuarioUseCase loginUsuarioUseCase;

  LoginUsuarioController({required this.loginUsuarioUseCase});

  Usuario? usuario;

  Future<Usuario?> login({
    required String email,
    required String senha,
  }) async {
    try {
      usuario = await loginUsuarioUseCase(email, senha);
      print('Usuário logado: ${usuario?.nome}');
      return usuario;
    } catch (e) {
      print('Erro ao fazer login: $e');
      rethrow;
    }
  }
}
