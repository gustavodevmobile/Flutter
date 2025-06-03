// Fonte de dados remota para cadastro
abstract class CadastroProfissionalDatasource {
  Future<Map<String, dynamic>> cadastrarProfissional(Map<String, dynamic> data);
}
