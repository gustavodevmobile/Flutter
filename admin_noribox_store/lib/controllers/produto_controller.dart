import 'package:admin_noribox_store/services/produto_service.dart';
import 'package:flutter/material.dart';
import '../models/produto.dart';

class ProdutoController extends ChangeNotifier {
  final Service service; // Injetado via construtor
  List<Produto> produtos = [];

  ProdutoController({required this.service});

  Future<Produto> cadastrarProdutoController(Produto produto) async {
    notifyListeners();
    try {
      final result = await service.cadastrarProdutoService(produto);
      notifyListeners();
      return result;
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Produto>> buscarProdutosController() async {
    try {
      produtos = await service.buscarProdutosService();
      notifyListeners();
      return produtos;
    } catch (error) {
      throw Exception('Erro ao buscar produtos: $error');
    }
  }

  Future<String> deletarProdutoController(String id) async {
    try {
      await service.deletarProdutoService(id);
      await buscarProdutosController(); // Atualiza a lista após deleção
      notifyListeners();
      return 'Produto deletado com sucesso';
    } catch (error) {
      rethrow;
    }
  }

  Future<Produto> editarProdutoController(Produto produto) async {
  try {
    final result = await service.editarProdutoService(produto);
    await buscarProdutosController(); // Atualiza a lista após edição
    notifyListeners();
    return result;
  } catch (error) {
    rethrow;
  }
}
}
