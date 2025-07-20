import 'package:noribox_store/models/endereco_usuario_,model.dart';

class ClienteModel {
  String? id;
  String nomeCompleto;
  String email;
  String senha;
  String cpfCnpj;
  String celular;
  String? telefone;
  DateTime dataNascimento;
  String genero;
  List<EnderecoClienteModel>? enderecos;

  ClienteModel({
    this.id,
    required this.nomeCompleto,
    required this.email,
    required this.senha,
    required this.cpfCnpj,
    required this.celular,
    this.telefone,
    required this.dataNascimento,
    required this.genero,
    this.enderecos = const [],
  });

  factory ClienteModel.fromJson(Map<String, dynamic> json) => ClienteModel(
        id: json['id'],
        nomeCompleto: json['nomeCompleto'],
        email: json['email'],
        senha: json['senha'],
        cpfCnpj: json['cpfCnpj'],
        celular: json['celular'],
        telefone: json['telefone'],
        dataNascimento: DateTime.parse(json['dataNascimento']),
        genero: json['genero'],
        enderecos: (json['enderecos'] as List<dynamic>?)
                ?.map((e) => EnderecoClienteModel.fromJson(e))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nomeCompleto': nomeCompleto,
        'email': email,
        'senha': senha,
        'cpfCnpj': cpfCnpj,
        'celular': celular,
        'telefone': telefone,
        'dataNascimento': dataNascimento.toIso8601String(),
        'genero': genero,
        'enderecos': enderecos != null ? enderecos!.map((e) => e.toJson()).toList() : [],
      };
}