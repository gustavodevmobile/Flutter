import 'package:flutter/material.dart';

class CarrinhoController extends ChangeNotifier {
  final List<Map<String, dynamic>> produtosId = [];

  void limparCarrinho() {
    produtosId.clear();
    notifyListeners();
  }

  void atualizarQuantidade(String id, int novaQuantidade) {
    final index = produtosId.indexWhere((produto) => produto['id'] == id);
    if (index != -1) {
      produtosId[index]['quantidade'] = novaQuantidade;
      notifyListeners();
    }
  }

  void adicionarProduto(Map<String, dynamic> resumoProduto) {
    // Verifica se o produto já está no carrinho
    final index = produtosId
        .indexWhere((produto) => produto['id'] == resumoProduto['id']);
    if (index != -1) {
      // Produto já existe, atualiza a quantidade
      produtosId[index]['quantidade'] = (produtosId[index]['quantidade'] ?? 1) +
          (resumoProduto['quantidade'] ?? 1);
    } else {
      // Produto não existe, adiciona normalmente
      produtosId.add(resumoProduto);
    }
    notifyListeners();
  }

  void removerProduto(String id) {
    produtosId.removeWhere((produto) => produto['id'] == id);
    notifyListeners();
  }
}
