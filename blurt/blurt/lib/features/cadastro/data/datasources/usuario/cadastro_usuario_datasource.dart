abstract class CadastroUsuarioDatasource {
  /// Cadastra um usuário com os dados fornecidos.
  ///
  /// Retorna uma [String] com o ID do usuário cadastrado.
  Future<String> cadastroUsuario(Map<String, dynamic> data);

  
}