import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://10.0.2.2:3000';

  Future<http.Response> cadastrarUsuario(Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl/usuario');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  Future<http.Response> cadastrarProfissional(Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl/profissional');
    print(data['valorConsulta']);
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  Future<http.Response> loginUsuario(String email, String senha) async {
    final url = Uri.parse('$_baseUrl/usuario/login');
    final data = {'email': email, 'senha': senha};
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  Future<http.Response> loginProfissional(String crp, String senha) async {
    final url = Uri.parse('$_baseUrl/profissional/login');
    final data = {'crp': crp, 'senha': senha};
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  Future<http.Response> getProfissionalById(String id) async {
    final url = Uri.parse('$_baseUrl/profissional/$id');
    return await http.get(url);
  }
}
