import 'package:blurt/models/profissional/profissional.dart';
import 'package:flutter/material.dart';
import '../../domain/usecases/login_profissional_usecase.dart';

class LoginProfissionalController extends ChangeNotifier {
  final LoginProfissionalUseCase loginUseCase;
  LoginProfissionalController(this.loginUseCase);

  Profissional? profissional;

  Future<Profissional?> login(String cpf, String senha) async {
    try {
      profissional = await loginUseCase(cpf, senha);
      return profissional;
    } catch (e) {
      rethrow;
    }
  }
}
