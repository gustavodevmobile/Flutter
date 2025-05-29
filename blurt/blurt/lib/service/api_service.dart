import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://10.0.2.2:3000';

  Future<http.Response> cadastrarUsuario(Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl/usuario');
    print('Datadd: {$data["dataNascimento"]}');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  Future<http.Response> cadastrarProfissional(Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl/profissional');
    print('Data: ${data["abordagemPrincipalId"]}');
    print('Data: ${data["especialidadePrincipalId"]}');
   

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

  Future<http.Response> loginProfissional(String cpf, String senha) async {
    final url = Uri.parse('$_baseUrl/profissional/login');
    final data = {'cpf': cpf, 'senha': senha};
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  Future<http.Response> getProfissionalOnline() async {
    final url = Uri.parse('$_baseUrl/profissionais/online');
    return await http.get(url);
  }

  Future<http.Response> getAbordagemPrincipal() async {
    final url = Uri.parse('$_baseUrl/abordagem-principal');
    return await http.get(url);
  }

  Future<http.Response> getAbordagensUtilizadas() async {
    final url = Uri.parse('$_baseUrl/abordagens-utilizdas');
    return await http.get(url);
  }

  Future<http.Response> getEspecialidadePrincipal() async {
    final url = Uri.parse('$_baseUrl/especialidade-principal');
    return await http.get(url);
  }

  Future<http.Response> getEspecialidadeOutras() async {
    final url = Uri.parse('$_baseUrl/especialidade-outras');
    return await http.get(url);
  }

  Future<http.Response> getTemasClinicos() async {
    final url = Uri.parse('$_baseUrl/temas-clinicos');
    return await http.get(url);
  }

  Future<http.Response> removerProfissionalPorCpf(String cpf) async {
    final url = Uri.parse('$_baseUrl/remove-profissional');
    print(cpf);
    final data = {'cpf': cpf};
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  

  
  
  
}
