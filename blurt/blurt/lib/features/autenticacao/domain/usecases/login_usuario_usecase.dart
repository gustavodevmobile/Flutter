import '../../../../shared/usuario/usuario.dart';
import '../repositories/login_repository.dart';

class LoginUsuarioUseCase {
  final LoginRepository repository;
  LoginUsuarioUseCase(this.repository);

  Future<Usuario> call(String email, String senha) {
    return repository.login(email, senha);
  }
}
