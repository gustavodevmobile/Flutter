import 'package:flutter/material.dart';

class CarrinhoController extends ChangeNotifier {
  final List<Map<String, dynamic>> produtosId = [];

  void adicionarProduto(Map<String, dynamic> resumoProduto) {
    produtosId.add(resumoProduto);
    notifyListeners();
  }

  void removerProduto(String id) {
    produtosId.removeWhere((produto) => produto['id'] == id);
    notifyListeners();
  }
}
