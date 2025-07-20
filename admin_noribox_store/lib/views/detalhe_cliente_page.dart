import 'package:flutter/material.dart';
import 'package:admin_noribox_store/models/cliente.dart';

class DetalheClientePage extends StatelessWidget {
  final Cliente cliente;
  const DetalheClientePage({required this.cliente, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalhes do Cliente')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(children: [
          Text('Nome: ${cliente.nomeCompleto}', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 12),
          Text('Email: ${cliente.email ?? '-'}'),
          Text('Celular: ${cliente.celular ?? '-'}'),
          Text('Telefone: ${cliente.telefone ?? '-'}'),
          Text('CPF/CNPJ: ${cliente.cpfCnpj ?? '-'}'),
          Text('Gênero: ${cliente.genero ?? '-'}'),
          Text('Data de Nascimento: ${cliente.dataNascimento ?? '-'}'),
          const SizedBox(height: 12),
          const Text('Endereços Cadastrados:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          if (cliente.enderecos != null && cliente.enderecos!.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: cliente.enderecos?.length ?? 0,
              itemBuilder: (context, index) {
                final endereco = cliente.enderecos![index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${endereco.rua}'),
                    Text('Número: ${endereco.numero}'),
                    Text('Complemento: ${endereco.complemento} '),
                    Text('Bairro: ${endereco.bairro}'),
                    Text('Cidade: ${endereco.cidade}'),
                    Text('Cidade: ${endereco.estado}'),
                    Text('Cep: ${endereco.cep}'),
                    SizedBox(height: 8),
                  ],
                );
              },
            )
          else
            const Text('Nenhum endereço cadastrado.'),
        ]),
      ),
    );
  }
}
