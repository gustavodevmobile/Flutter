import 'package:flutter/material.dart';
import '../../domain/usecases/login_usuario_usecase.dart';
import '../../../../models/usuario/usuario.dart';

class LoginUsuarioController extends ChangeNotifier {
  final LoginUsuarioUseCase loginUsuarioUseCase;

  bool _loading = false;
  bool get loading => _loading;

  LoginUsuarioController({required this.loginUsuarioUseCase});

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<Usuario?> login({
    required BuildContext context,
    required String email,
    required String senha,
    required GlobalKey<FormState> formKey,
  }) async {
    if (!formKey.currentState!.validate()) return null;

    setLoading(true);
    try {
      final usuario = await loginUsuarioUseCase(email, senha);
      // Aqui você pode salvar o usuário no Provider, navegar, etc.
      setLoading(false);
      print('Usuário logado: $usuario');
      return usuario;
    } catch (e) {
      setLoading(false);
      rethrow;
    }
  }
}
