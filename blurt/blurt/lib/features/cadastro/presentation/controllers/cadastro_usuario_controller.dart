import 'package:blurt/features/cadastro/domain/usecases/cadastro_usuario_usecase.dart';
import 'package:flutter/material.dart';

import '../../../../models/usuario/usuario.dart';

class CadastroUsuarioController extends ChangeNotifier {
  final CadastrarUsuarioUseCase cadastrarUseCase;
  CadastroUsuarioController(this.cadastrarUseCase);

  Future<String> cadastrarUsuario(Usuario usuario) async {
    try {
      final result = await cadastrarUseCase(usuario);
      notifyListeners();
      return result;
    } catch (error) {
      notifyListeners();
      rethrow;
    }
  }
}
