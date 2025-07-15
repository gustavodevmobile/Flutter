class EnderecoClienteModel {
  String? id;
  String cep;
  String logradouro;
  String numero;
  String complemento;
  String bairro;
  String cidade;
  String estado;

  EnderecoClienteModel({
    this.id,
    required this.cep,
    required this.logradouro,
    required this.numero,
    required this.complemento,
    required this.bairro,
    required this.cidade,
    required this.estado,
  });

  factory EnderecoClienteModel.fromJson(Map<String, dynamic> json) => EnderecoClienteModel(
        id: json['id'],
        cep: json['cep'],
        logradouro: json['logradouro'],
        numero: json['numero'],
        complemento: json['complemento'],
        bairro: json['bairro'],
        cidade: json['cidade'],
        estado: json['estado'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'cep': cep,
        'logradouro': logradouro,
        'numero': numero,
        'complemento': complemento,
        'bairro': bairro,
        'cidade': cidade,
        'estado': estado,
      };
}