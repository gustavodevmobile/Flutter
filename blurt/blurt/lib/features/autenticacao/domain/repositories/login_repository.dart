import '../../../../shared/usuario/usuario.dart';

abstract class LoginRepository {
  Future<Usuario> login(String email, String senha);
}
