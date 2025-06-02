import '../../../../shared/profissinal/profissional.dart';
import '../repositories/login_profissional_repository.dart';

class LoginProfissionalUseCase {
  final LoginProfissionalRepository repository;
  LoginProfissionalUseCase(this.repository);

  Future<Profissional> call(String cpf, String senha) {
    return repository.login(cpf, senha);
  }
}
