// Exemplo de função para abrir a tela intermediária
import 'package:flutter/material.dart';
import 'package:noribox_store/models/produtos_models.dart';
import 'package:noribox_store/service/produtos_service.dart';
import 'package:noribox_store/views/checkout_pagamento_screen.dart';

final service = ProdutosService();

void abrirTelaCheckout(BuildContext context, Produto produto) async {
  final resultado = await showDialog<Map<String, dynamic>>(
    context: context,
    builder: (context) {
      final quantidadeController = TextEditingController(text: '1');
      return AlertDialog(
        title: Text('Confirmar compra'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Produto: ${produto.nome}'),
            Text('Valor: R\$ ${produto.valor.toStringAsFixed(2)}'),
            TextField(
              controller: quantidadeController,
              decoration: const InputDecoration(labelText: 'Quantidade'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, {
                'quantidade': int.tryParse(quantidadeController.text) ?? 1,
              });
            },
            child: const Text('Confirmar'),
          ),
        ],
      );
    },
  );

  if (resultado != null) {
    // Chame o backend para criar a preferência
    final preferenceId = await service.criarPreferenceId(
      nome: produto.nome,
      valor: produto.valor * resultado['quantidade'],
      quantidade: resultado['quantidade'],
    );
    
    if (preferenceId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CheckoutBricksPage(
            preferenceId: preferenceId,
            amount: produto.valor * resultado['quantidade'],
            publicKey: 'TEST-9f5523a7-05ff-4478-a030-557514887057',
          ),
        ),
      );
    }
  }
}
