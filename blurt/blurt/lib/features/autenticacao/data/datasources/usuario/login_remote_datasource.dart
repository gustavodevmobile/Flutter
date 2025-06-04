// Fonte de dados remota para login
abstract class LoginRemoteDatasource {
  Future<Map<String, dynamic>> login(String email, String senha);
}
