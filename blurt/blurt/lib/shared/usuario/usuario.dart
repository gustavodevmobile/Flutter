// Entidade de domínio para o usuário
class Usuario {
  final String? id;
  final String name;
  final String email;
  final String? telefone;
  final String passwordHash;
  final String cpf;
  final String gender;
  final DateTime? createdAt;
  final String? foto;
  final DateTime? dataNascimento;

  Usuario({
    this.id,
    required this.name,
    required this.email,
    this.telefone,
    required this.passwordHash,
    required this.cpf,
    required this.gender,
    this.createdAt,
    this.foto,
    this.dataNascimento,
  });
}
