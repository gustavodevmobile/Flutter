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
  final bool emAtendimento;
  final double valorConsulta;
  final String genero;
  final String foto;
  final String? imagemDocumento;
  final String imagemSelfieComDoc;
  final DateTime? createdAt;
  final String? chavePix;
  final String? contaBancaria;
  final String? agencia;
  final String? banco;
  final String? tipoConta;
  String? abordagemPrincipal;
  final List<String>? abordagensUtilizadas;
  String? especialidadePrincipal;
  final List<String>? temasClinicos;
  final String? certificadoEspecializacao;

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
    this.emAtendimento = false,
    required this.valorConsulta,
    required this.genero,
    required this.foto,
    this.imagemDocumento,
    required this.imagemSelfieComDoc,
    this.createdAt,
    this.chavePix,
    this.contaBancaria,
    this.agencia,
    this.banco,
    this.tipoConta,
    this.abordagemPrincipal,
    this.abordagensUtilizadas,
    this.especialidadePrincipal,
    this.temasClinicos,
    this.certificadoEspecializacao,
  });

  factory Professional.fromJson(Map<String, dynamic> json) {
    return Professional(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      passwordHash: json['password_hash'] ?? '',
      bio: json['bio'] ?? '',
      cpf: json['cpf'] ?? '',
      cnpj: json['cnpj'] ?? '',
      crp: json['CRP'] ?? '',
      diplomaPsicanalista: json['diplomaPsicanalista'] ?? '',
      declSupClinica: json['declSupClinica'] ?? '',
      declAnPessoal: json['declAnPessoal'] ?? '',
      tipoProfissional: json['tipoProfissional'],
      estaOnline: json['estaOnline'] ?? false,
      atendePlantao: json['atendePlantao'] ?? false,
      emAtendimento: json['emAtendimento'] ?? false,
      valorConsulta: double.tryParse(json['valorConsulta'].toString()) ?? 0.0,
      genero: json['genero'] ?? '',
      foto: json['foto'] ?? '',
      imagemDocumento: json['imagemDocumento'] ?? '',
      imagemSelfieComDoc: json['imagemSelfieComDoc'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      chavePix: json['chavePix'] ?? '',
      contaBancaria: json['contaBancaria'] ?? '',
      agencia: json['agencia'] ?? '',
      banco: json['banco'] ?? '',
      tipoConta: json['tipoConta'] ?? '',
      abordagemPrincipal: json['abordagemPrincipal'] ?? '',
      abordagensUtilizadas: (json['abordagensUtilizadas'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      especialidadePrincipal: json['especialidadePrincipal'] ?? '',
      temasClinicos:
          (json['temasClinicos'] as List?)?.map((e) => e.toString()).toList(),
      certificadoEspecializacao: json['certificadoEspecializacao'] ?? '',
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
        'diplomaPsicanalista': diplomaPsicanalista,
      if (declSupClinica != null) 'declSupClinica': declSupClinica,
      if (declAnPessoal != null) 'declAnPessoal': declAnPessoal,
      'tipoProfissional': tipoProfissional,
      'estaOnline': estaOnline,
      'atendePlantao': atendePlantao,
      'emAtedimento': emAtendimento,
      'valorConsulta': valorConsulta,
      'genero': genero,
      'foto': foto,
      'imagemDocumento': imagemDocumento,
      'imagemSelfieComDoc': imagemSelfieComDoc,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (chavePix != null) 'chavePix': chavePix,
      if (contaBancaria != null) 'contaBancaria': contaBancaria,
      if (agencia != null) 'agencia': agencia,
      if (banco != null) 'banco': banco,
      if (tipoConta != null) 'tipoConta': tipoConta,
      'abordagemPrincipal': abordagemPrincipal,
      if (abordagensUtilizadas != null)
        'abordagensUtilizadas': abordagensUtilizadas,
      if (especialidadePrincipal != null)
        'especialidadePrincipal': especialidadePrincipal,
      if (temasClinicos != null) 'temasClinicos': temasClinicos,
    };
  }
}
