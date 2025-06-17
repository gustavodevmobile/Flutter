// Entidade de domínio para o usuário
class Usuario {
  final String? id;
  final String? tokenFcm;
  final String nome;
  final String estado;
  final String cidade;
  final String email;
  final String? telefone;
  final String senha;
  final String cpf;
  final String genero;
  final DateTime? createdAt;
  final String? foto;
  final DateTime? dataNascimento;

  Usuario({
    this.id,
    this.tokenFcm,
    required this.nome,
    required this.estado,
    required this.cidade,
    required this.email,
    this.telefone,
    required this.senha,
    required this.cpf,
    required this.genero,
    this.createdAt,
    this.foto,
    this.dataNascimento,
  });
}
