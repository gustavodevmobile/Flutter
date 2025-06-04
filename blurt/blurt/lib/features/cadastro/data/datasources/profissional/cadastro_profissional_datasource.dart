// Fonte de dados remota para cadastro
abstract class CadastroProfissionalDatasource {
  Future<String> cadastrarProfissional(Map<String, dynamic> data);
}
