import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/categoria.dart';

class CategoriaService {
  final String baseUrl = dotenv.env['API_URL'] ?? '';

  Future<List<Categoria>> buscarCategorias() async {
    final url = Uri.parse('$baseUrl/categorias');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Categoria.fromJson(item)).toList();
    } else {
      throw Exception('Erro ao buscar categorias: ${response.body}');
    }
  }

  Future<Categoria> cadastrarCategoria(String categoria) async {
    final url = Uri.parse('$baseUrl/cadastrar-categoria');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nome': categoria}),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Categoria.fromJson(data);
    } else {
      throw Exception('Erro ao cadastrar categoria: ${response.body}');
    }
  }
}
