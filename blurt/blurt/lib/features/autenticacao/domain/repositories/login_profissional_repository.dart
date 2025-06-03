import '../../../../shared/profissional/profissional.dart';

abstract class LoginProfissionalRepository {
  Future<Profissional> login(String cpf, String senha);
}
