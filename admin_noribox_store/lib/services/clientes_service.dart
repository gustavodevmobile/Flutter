import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/cliente.dart';

class ClientesService {
  final String baseUrl = dotenv.env['API_URL'] ?? '';

  Future<List<Cliente>> buscarClientes() async {
    final url = Uri.parse('$baseUrl/clientes/clientes');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      //print('Dados recebidos: $data');
      return data.map((item) => Cliente.fromJson(item)).toList();
    } else {
      throw Exception('Erro ao buscar clientes: ${response.body}');
    }
  }

  Future<bool> excluirCliente(String id) async {
    final url = Uri.parse('$baseUrl/clientes/deletar$id');
    final response = await http.delete(url);
    if (response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Erro ao excluir cliente: ${response.body}');
    }
  }
}
