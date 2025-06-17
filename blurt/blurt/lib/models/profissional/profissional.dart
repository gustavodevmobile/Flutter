class Profissional {
  final String? id;
  final String? tokenFcm;
  final String nome;
  final String estado;
  final String cidade;
  final String email;
  final String senha;
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
  final bool logado;
  final double valorConsulta;
  final String genero;
  final String foto;
  final String imagemDocumento;
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

  Profissional({
    this.id,
    this.tokenFcm,
    required this.nome,
    required this.estado,
    required this.cidade,
    required this.email,
    required this.senha,
    this.bio,
    required this.cpf,
    this.cnpj,
    this.crp,
    this.diplomaPsicanalista,
    this.declSupClinica,
    this.declAnPessoal,
    required this.tipoProfissional,
    required this.estaOnline,
    required this.atendePlantao,
    required this.emAtendimento,
    required this.logado,
    required this.valorConsulta,
    required this.genero,
    required this.foto,
    required this.imagemDocumento,
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
}
