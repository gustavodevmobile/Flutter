import 'package:blurt/models/usuario/usuario.dart';

abstract class CadastroUsuarioRepositories {
  Future<String> cadastrarUsuario(Usuario usuario);
}
