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
    print('Logging in with CPF: $cpf and Senha: $senha');
    final apiUrl = dotenv.env['API_URL'];
    final response = await client.post(
      Uri.parse('$apiUrl/profissional/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'cpf': cpf, 'senha': senha}),
    );
    final body = jsonDecode(response.body);
    //print('Response body: $body');
    if (response.statusCode == 200) {
      return body;
    } else {
      //print('Response from login:');
      throw body['message'] ?? 'Erro ao fazer login';
    }
  }
}
