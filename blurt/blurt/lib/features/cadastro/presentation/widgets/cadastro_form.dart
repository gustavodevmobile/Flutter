import 'package:flutter/material.dart';

class CadastroForm extends StatelessWidget {
  const CadastroForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(decoration: const InputDecoration(labelText: 'Nome')),
        TextFormField(decoration: const InputDecoration(labelText: 'E-mail')),
        ElevatedButton(onPressed: () {}, child: const Text('Cadastrar')),
      ],
    );
  }
}
