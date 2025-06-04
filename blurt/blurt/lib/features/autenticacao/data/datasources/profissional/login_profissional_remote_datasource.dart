// Fonte de dados remota para login de profissional
abstract class LoginProfissionalRemoteDatasource {
  Future<Map<String, dynamic>> login(String cpf, String senha);
}
