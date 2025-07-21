import 'dart:convert';
import 'package:hive/hive.dart';

class CarrinhoPreferences {
  static const String _keyCarrinho = 'carrinho_produtos';

  // Salvar produto (adiciona se não existir)
  static Future<void> salvarProdutos(Map<String, dynamic> novoProduto) async {
    final box = await Hive.openBox(_keyCarrinho);
    final produtos = box.get('produtos', defaultValue: <String>[]) as List;
    final lista =
        produtos.map((p) => jsonDecode(p) as Map<String, dynamic>).toList();

    final existe = lista.any((produto) => produto['id'] == novoProduto['id']);
    if (!existe) {
      lista.add(novoProduto);
      final novaListaSerializada = lista.map((p) => jsonEncode(p)).toList();
      await box.put('produtos', novaListaSerializada);
    }
  }

  // Atualizar quantidade
  static Future<void> atualizarQuantidade(String id, int novaQuantidade) async {
    try {
      final box = await Hive.openBox(_keyCarrinho);
      final produtos = box.get('produtos', defaultValue: <String>[]) as List;
      final lista =
          produtos.map((p) => jsonDecode(p) as Map<String, dynamic>).toList();

      final index = lista.indexWhere((produto) => produto['id'] == id);
      if (index != -1) {
        lista[index]['quantidade'] = novaQuantidade;
        final novaListaSerializada = lista.map((p) => jsonEncode(p)).toList();
        await box.put('produtos', novaListaSerializada);
        print('Quantidade atualizada: $id para $novaQuantidade');
      }
    } catch (e) {
      print('Erro ao atualizar quantidade: $e');
      //throw Exception('Erro ao atualizar quantidade do produto: $id');
    }
  }

  // Recuperar lista de produtos
  static Future<List<Map<String, dynamic>>> recuperarProdutos() async {
    final box = await Hive.openBox(_keyCarrinho);
    final produtos = box.get('produtos', defaultValue: <String>[]) as List;
    return produtos.map((p) => jsonDecode(p) as Map<String, dynamic>).toList();
  }

  // Remover produto pelo id
  static Future<void> removerProduto(String id) async {
    final box = await Hive.openBox(_keyCarrinho);
    final produtos =
        box.get('produtos', defaultValue: <String>[]) as List;
    final lista =
        produtos.map((p) => jsonDecode(p) as Map<String, dynamic>).toList();

    lista.removeWhere((produto) => produto['id'] == id);
    final novaListaSerializada = lista.map((p) => jsonEncode(p)).toList();
    await box.put('produtos', novaListaSerializada);
  }

  // Limpar carrinho
  static Future<void> limparCarrinho() async {
    final box = await Hive.openBox(_keyCarrinho);
    await box.delete('produtos');
    print('Carrinho limpo');
  }
}
