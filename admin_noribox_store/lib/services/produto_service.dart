import 'dart:convert';
import 'package:admin_noribox_store/models/produto.dart';
import 'package:admin_noribox_store/widgets/exception.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Service {
  final String baseUrl = dotenv.env['API_URL'] ?? '';

  Future<Produto> cadastrarProdutoService(Produto produto) async {
    try {
      final url = Uri.parse('$baseUrl/produtos/cadastrar');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(produto.toMap()),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Produto.fromJson(data);
      } else {
        throw Exception('Erro ao cadastrar produto: ${response.body}');
      }
    } catch (error) {
      throw AppException('Erro ao cadastrar produto: $error');
    }
  }

  Future<List<Produto>> buscarProdutosService() async {
    final url = Uri.parse('$baseUrl/produtos/produtos');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Produto.fromJson(item)).toList();
    } else {
      throw AppException('Erro ao buscar produtos: ${response.body}');
    }
  }

  Future<String> deletarProdutoService(String id) async {
    final url = Uri.parse('$baseUrl/produtos/deletar/$id');
    final response = await http.delete(url);

    if (response.statusCode == 200 || response.statusCode == 204) {
      print(response.body);
      return 'Produto deletado com sucesso';
    } else {
      throw AppException('Erro ao deletar produto: ${response.body}');
    }
  }

  Future<Produto> editarProdutoService(Produto produto) async {
    final url = Uri.parse('$baseUrl/produtos/editar/${produto.id}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(produto.toMap()),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Produto.fromJson(data);
    } else {
      throw AppException('Erro ao editar produto: ${response.body}');
    }
  }
}
