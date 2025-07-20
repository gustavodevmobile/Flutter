
import 'package:admin_noribox_store/models/endereco_cliente.dart';
import 'package:admin_noribox_store/utils/formatters.dart';

class Cliente {
  final String? id;
  final String nomeCompleto;
  final String? email;
  final String? celular;
  final String? telefone;
  final String? cpfCnpj;
  final String? genero;
  final String? dataNascimento;
  final List<EnderecoCliente>? enderecos;

  Cliente({
    this.id,
    required this.nomeCompleto,
    this.email,
    this.celular,
    this.telefone,
    this.cpfCnpj,
    this.genero,
    this.dataNascimento,
    this.enderecos,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'] ?? 'Não informado',
      nomeCompleto: json['nomeCompleto'] ?? 'Não informado',
      email: json['email'] ?? 'Não informado',
      celular: json['celular'] ?? 'Não informado',
      telefone: json['telefone'] ?? 'Não informado',
      cpfCnpj: json['cpfCnpj'] ?? 'Não informado',
      genero: json['genero'] ?? 'Não informado',
      dataNascimento: Formatters.formatarData(json['dataNascimento']),
      enderecos: (json['enderecos'] as List?)
          ?.map((e) => EnderecoCliente.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nomeCompleto,
        'email': email,
        'celular': celular,
        'telefone': telefone,
        'cpf': cpfCnpj,
        'genero': genero,
        'data_nascimento': dataNascimento,
        //'endereco': enderecos?.toJson(),
      };
}
