class EnderecoClienteModel {
  String? id;
  String clienteId;
  String cep;
  String rua;
  String numero;
  String complemento;
  String bairro;
  String cidade;
  String estado;

  EnderecoClienteModel({
    this.id,
    required this.clienteId,
    required this.cep,
    required this.rua,
    required this.numero,
    required this.complemento,
    required this.bairro,
    required this.cidade,
    required this.estado,
  });

  factory EnderecoClienteModel.fromJson(Map<String, dynamic> json) => EnderecoClienteModel(
        id: json['id'],
        clienteId: json['clienteId'],
        cep: json['cep'],
        rua: json['rua'],
        numero: json['numero'],
        complemento: json['complemento'],
        bairro: json['bairro'],
        cidade: json['cidade'],
        estado: json['estado'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'clienteId': clienteId,
        'cep': cep,
        'rua': rua,
        'numero': numero,
        'complemento': complemento,
        'bairro': bairro,
        'cidade': cidade,
        'estado': estado,
      };
}