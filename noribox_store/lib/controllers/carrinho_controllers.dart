import 'package:flutter/material.dart';
import 'package:noribox_store/hive/carrinho_storage_hive.dart';

class CarrinhoController extends ChangeNotifier {
  List<Map<String, dynamic>> produtosId = [];

  void limparCarrinho() {
    CarrinhoPreferences.limparCarrinho();
    produtosId.clear();
    print('Carrinho limpo');
    notifyListeners();
  }

  Future<void> atualizarQuantidade(String id, int novaQuantidade) async {
    await CarrinhoPreferences.atualizarQuantidade(id, novaQuantidade);
    final index = produtosId.indexWhere((produto) => produto['id'] == id);
    if (index != -1) {
      produtosId[index]['quantidade'] = novaQuantidade;
      print('Quantidade atualizada: $id para $novaQuantidade');
    } else {
      print('Produto não encontrado: $id');
    }
    produtosId = await CarrinhoPreferences.recuperarProdutos();
    notifyListeners();
  }

  Future<void> recuperarProdutos() async {
    produtosId = await CarrinhoPreferences.recuperarProdutos();
    print('Produtos recuperados: $produtosId');
    notifyListeners();
  }

  Future<void> adicionarProduto(Map<String, dynamic> resumoProduto) async {
    await CarrinhoPreferences.salvarProdutos(resumoProduto);
    produtosId = await CarrinhoPreferences.recuperarProdutos();
    print('Produtos adicionado : ${resumoProduto['descricao']}');
    notifyListeners();
  }

  Future<void> removerProduto(String id) async {
    try {
      await CarrinhoPreferences.removerProduto(id);
      produtosId.removeWhere((produto) => produto['id'] == id);
      print('Produto removido: $id');
      notifyListeners();
    } catch (e) {
      print('Erro ao remover produto: $e');
      // Você pode optar por lançar uma exceção ou lidar com o erro de outra forma
      // throw Exception('Erro ao remover produto: $id');
    }
  }
}
