class Usuario {
  final String? id;
  final String name;
  final String email;
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
    required this.passwordHash,
    required this.cpf,
    required this.gender,
    this.createdAt,
    this.foto,
    this.dataNascimento,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] as String?,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
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
