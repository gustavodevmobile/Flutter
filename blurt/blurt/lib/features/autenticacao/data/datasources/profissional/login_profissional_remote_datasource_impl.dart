import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'login_profissional_remote_datasource.dart';

class LoginProfissionalRemoteDatasourceImpl
    implements LoginProfissionalRemoteDatasource {
  final http.Client client;
  LoginProfissionalRemoteDatasourceImpl(this.client);

  @override
  Future<Map<String, dynamic>> login(String cpf, String senha) async {
    final apiUrl = dotenv.env['API_URL'];
    final response = await client.post(
      Uri.parse('$apiUrl/profissional/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'cpf': cpf, 'senha': senha}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao fazer login do profissional');
    }
  }
}
