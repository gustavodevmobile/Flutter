

import 'package:blurt/features/cadastro/data/repositories/cadastro_usuario_repository_impl.dart';
import 'package:blurt/models/usuario/usuario.dart';

class CadastrarUsuarioUseCase {
  final CadastroUsuarioRepositoriesImpl repository;
  CadastrarUsuarioUseCase(this.repository);

  Future<String> call(Usuario usuario) async {
    final user = await repository.cadastrarUsuario(usuario);
    return user;
  }
}
