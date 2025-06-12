import 'profissional.dart';

class ProfissionalModel extends Profissional {
  ProfissionalModel({
    super.id,
    required super.nome,
    required super.estado,
    required super.cidade,
    required super.email,
    required super.senha,
    super.bio,
    required super.cpf,
    super.cnpj,
    super.crp,
    super.diplomaPsicanalista,
    super.declSupClinica,
    super.declAnPessoal,
    required super.tipoProfissional,
    required super.estaOnline,
    required super.atendePlantao,
    required super.emAtendimento,
    required super.valorConsulta,
    required super.genero,
    required super.foto,
    required super.imagemDocumento,
    required super.imagemSelfieComDoc,
    super.createdAt,
    super.chavePix,
    super.contaBancaria,
    super.agencia,
    super.banco,
    super.tipoConta,
    super.abordagemPrincipal,
    super.abordagensUtilizadas,
    super.especialidadePrincipal,
    super.temasClinicos,
    super.certificadoEspecializacao,
  });

  factory ProfissionalModel.fromJson(Map<String, dynamic> json) {
    return ProfissionalModel(
      id: json['id'] as String?,
      nome: json['nome'] ?? '',
      estado: json['estado'] ?? '',
      cidade: json['cidade'] ?? '',
      email: json['email'] ?? '',
      senha: json['senha'] ?? '',
      bio: json['bio'] as String?,
      cpf: json['cpf'] ?? '',
      cnpj: json['cnpj'] as String?,
      crp: json['CRP'] as String?,
      diplomaPsicanalista: json['diplomaPsicanalista'] as String?,
      declSupClinica: json['declSupClinica'] as String?,
      declAnPessoal: json['declAnPessoal'] as String?,
      tipoProfissional: json['tipoProfissional'] ?? '',
      estaOnline: json['estaOnline'] ?? false,
      atendePlantao: json['atendePlantao'] ?? false,
      emAtendimento: json['emAtendimento'] ?? false,
      valorConsulta: (json['valorConsulta'] is int)
          ? (json['valorConsulta'] as int).toDouble()
          : (json['valorConsulta'] ?? 0.0),
      genero: json['genero'] ?? '',
      foto: json['foto'] ?? '',
      imagemDocumento: json['imagemDocumento'] ?? '',
      imagemSelfieComDoc: json['imagemSelfieComDoc'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      chavePix: json['chavePix'] as String?,
      contaBancaria: json['contaBancaria'] as String?,
      agencia: json['agencia'] as String?,
      banco: json['banco'] as String?,
      tipoConta: json['tipoConta'] as String?,
      abordagemPrincipal: json['abordagemPrincipal'] as String?,
      abordagensUtilizadas: (json['abordagensUtilizadas'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      especialidadePrincipal: json['especialidadePrincipal'] as String?,
      temasClinicos:
          (json['temasClinicos'] as List?)?.map((e) => e.toString()).toList(),
      certificadoEspecializacao: json['certificadoEspecializacao'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nome': nome,
      'estado': estado,
      'cidade': cidade,
      'email': email,
      'senha': senha,
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
      'emAtendimento': emAtendimento,
      'valorConsulta': valorConsulta,
      'genero': genero,
      'foto': foto,
      'imagemDocumento': imagemDocumento,
      'imagemSelfieComDoc': imagemSelfieComDoc,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (chavePix != null) 'chavePix': chavePix,
      if (contaBancaria != null) 'contaBancaria': contaBancaria,
      if (agencia != null) 'agencia': agencia,
      if (banco != null) 'banco': banco,
      if (tipoConta != null) 'tipoConta': tipoConta,
      if (abordagemPrincipal != null) 'abordagemPrincipal': abordagemPrincipal,
      if (abordagensUtilizadas != null)
        'abordagensUtilizadas': abordagensUtilizadas,
      if (especialidadePrincipal != null)
        'especialidadePrincipal': especialidadePrincipal,
      if (temasClinicos != null) 'temasClinicos': temasClinicos,
      if (certificadoEspecializacao != null)
        'certificadoEspecializacao': certificadoEspecializacao,
    };
  }

  
  factory ProfissionalModel.fromProfissional(Profissional p) {
    return ProfissionalModel(
      id: p.id,
      nome: p.nome,
      estado: p.estado,
      cidade: p.cidade,
      email: p.email,
      senha: p.senha,
      bio: p.bio,
      cpf: p.cpf,
      cnpj: p.cnpj,
      crp: p.crp,
      diplomaPsicanalista: p.diplomaPsicanalista,
      declSupClinica: p.declSupClinica,
      declAnPessoal: p.declAnPessoal,
      tipoProfissional: p.tipoProfissional,
      estaOnline: p.estaOnline,
      atendePlantao: p.atendePlantao,
      emAtendimento: p.emAtendimento,
      valorConsulta: p.valorConsulta,
      genero: p.genero,
      foto: p.foto,
      imagemDocumento: p.imagemDocumento,
      imagemSelfieComDoc: p.imagemSelfieComDoc,
      createdAt: p.createdAt,
      chavePix: p.chavePix,
      contaBancaria: p.contaBancaria,
      agencia: p.agencia,
      banco: p.banco,
      tipoConta: p.tipoConta,
      abordagemPrincipal: p.abordagemPrincipal,
      abordagensUtilizadas: p.abordagensUtilizadas,
      especialidadePrincipal: p.especialidadePrincipal,
      temasClinicos: p.temasClinicos,
      certificadoEspecializacao: p.certificadoEspecializacao,
    );
  }
}

