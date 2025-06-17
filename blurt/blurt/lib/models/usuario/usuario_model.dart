import 'usuario.dart';

class UsuarioModel extends Usuario {
  UsuarioModel({
    super.id,
    super.tokenFcm,
    required super.nome,
    required super.estado,
    required super.cidade,
    required super.email,
    super.telefone,
    required super.senha,
    required super.cpf,
    required super.genero,
    super.createdAt,
    super.foto,
    super.dataNascimento,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'] as String?,
      tokenFcm: json['tokenFcm'] as String?,
      nome: json['nome'] ?? '',
      estado: json['estado'] ?? '',
      cidade: json['cidade'] ?? '',
      email: json['email'] ?? '',
      telefone: json['telefone'] as String?,
      senha: json['senha'] ?? '',
      cpf: json['cpf'] ?? '',
      genero: json['genero'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      foto: json['foto'] as String?,
      dataNascimento: json['dataNascimento'] != null
          ? DateTime.tryParse(json['dataNascimento'])
          : null,
    );
  }

  factory UsuarioModel.fromUsuario(Usuario usuario) {
    return UsuarioModel(
      id: usuario.id,
      tokenFcm: usuario.tokenFcm,
      nome: usuario.nome,
      estado: usuario.estado,
      cidade: usuario.cidade,
      email: usuario.email,
      telefone: usuario.telefone,
      senha: usuario.senha,
      cpf: usuario.cpf,
      genero: usuario.genero,
      createdAt: usuario.createdAt,
      foto: usuario.foto,
      dataNascimento: usuario.dataNascimento,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (tokenFcm != null) 'tokenFcm': tokenFcm,
      'nome': nome,
      'estado': estado,
      'cidade': cidade,
      'email': email,
      if (telefone != null) 'telefone': telefone,
      'senha': senha,
      'cpf': cpf,
      'genero': genero,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (foto != null) 'foto': foto,
      if (dataNascimento != null)
        'dataNascimento': dataNascimento!.toIso8601String(),
    };
  }
}
