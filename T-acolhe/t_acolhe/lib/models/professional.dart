class Professional {
  final String? id;
  final String name;
  final String email;
  final String passwordHash;
  final String? bio;
  final String cpf;
  final String? cnpj;
  final String? crp;
  final String? diplomaPsicanalista;
  final String? declSupClinica;
  final String? declAnPessoal;
  final String tipoProfissional;
  final bool estaOnline;
  final bool atendePlantao;
  final double valorConsulta;
  final String genero;
  final String foto;
  final DateTime? createdAt;

  Professional({
    this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
    this.bio,
    required this.cpf,
    this.cnpj,
    this.crp,
    this.diplomaPsicanalista,
    this.declSupClinica,
    this.declAnPessoal,
    required this.tipoProfissional,
    this.estaOnline = false,
    this.atendePlantao = false,
    required this.valorConsulta,
    required this.genero,
    required this.foto,
    this.createdAt,
  });

  factory Professional.fromJson(Map<String, dynamic> json) {
    return Professional(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      passwordHash: json['password_hash'],
      bio: json['bio'],
      cpf: json['cpf'],
      cnpj: json['cnpj'],
      crp: json['crp'],
      diplomaPsicanalista: json['diploma_psicanalista'],
      declSupClinica: json['decl_sup_clinica'],
      declAnPessoal: json['decl_an_pessoal'],
      tipoProfissional: json['tipo_profissional'],
      estaOnline: json['esta_online'] ?? false,
      atendePlantao: json['atende_plantao'] ?? false,
      valorConsulta: (json['valor_consulta']),
          // ? (json['valor_consulta'] as int).toDouble()
          // : (json['valor_consulta'] as num).toDouble(),
      genero: json['genero'],
      foto: json['foto'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'email': email,
      'passwordHash': passwordHash,
      if (bio != null) 'bio': bio,
      'cpf': cpf,
      if (cnpj != null) 'cnpj': cnpj,
      if (crp != null) 'crp': crp,
      if (diplomaPsicanalista != null)
        'diploma_psicanalista': diplomaPsicanalista,
      if (declSupClinica != null) 'decl_sup_clinica': declSupClinica,
      if (declAnPessoal != null) 'decl_an_pessoal': declAnPessoal,
      'tipoProfissional': tipoProfissional,
      'estaOnline': estaOnline,
      'atendePlantao': atendePlantao,
      'valorConsulta': valorConsulta,
      'genero': genero,
      'foto': foto,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }
}
