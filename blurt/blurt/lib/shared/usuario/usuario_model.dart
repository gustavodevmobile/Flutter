import 'usuario.dart';

class UsuarioModel extends Usuario {
  UsuarioModel({
    super.id,
    required super.name,
    required super.email,
    super.telefone,
    required super.passwordHash,
    required super.cpf,
    required super.gender,
    super.createdAt,
    super.foto,
    super.dataNascimento,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'] as String?,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      telefone: json['telefone'] as String?,
      passwordHash: json['passwordHash'] ?? '',
      cpf: json['cpf'] ?? '',
      gender: json['gender'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      foto: json['foto'] as String?,
      dataNascimento: json['dataNascimento'] != null
          ? DateTime.tryParse(json['dataNascimento'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'email': email,
      if (telefone != null) 'telefone': telefone,
      'passwordHash': passwordHash,
      'cpf': cpf,
      'gender': gender,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (foto != null) 'foto': foto,
      if (dataNascimento != null)
        'dataNascimento': dataNascimento!.toIso8601String(),
    };
  }
}
