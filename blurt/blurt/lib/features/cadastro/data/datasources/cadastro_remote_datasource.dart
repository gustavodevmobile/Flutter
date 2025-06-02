// Fonte de dados remota para cadastro
abstract class CadastroRemoteDatasource {
  Future<Map<String, dynamic>> cadastrar(Map<String, dynamic> data);
}
