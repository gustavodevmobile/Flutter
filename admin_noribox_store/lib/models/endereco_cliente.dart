class EnderecoCliente {
  final String? id;
  final String? rua;
  final String? numero;
  final String? complemento;
  final String? bairro;
  final String? cidade;
  final String? estado;
  final String? cep;

  EnderecoCliente({
    this.id,
    this.rua,
    this.numero,
    this.complemento,
    this.bairro,
    this.cidade,
    this.estado,
    this.cep,
  });

  factory EnderecoCliente.fromJson(Map<String, dynamic> json) {
    return EnderecoCliente(
      id: json['id'] ?? 'Não informado',
      rua: json['rua'] ?? 'Não informado',
      numero: json['numero'] ?? 'Não informado',
      complemento: json['complemento'] ?? 'Não informado',
      bairro: json['bairro'] ?? 'Não informado',
      cidade: json['cidade'] ?? 'Não informado',
      estado: json['estado'] ?? 'Não informado',
      cep: json['cep'] ?? 'Não informado',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'rua': rua,
        'numero': numero,
        'complemento': complemento,
        'bairro': bairro,
        'cidade': cidade,
        'estado': estado,
        'cep': cep,
      };
}