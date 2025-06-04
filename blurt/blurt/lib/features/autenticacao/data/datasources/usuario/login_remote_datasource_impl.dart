import 'dart:convert';
import 'package:http/http.dart' as http;
import 'login_remote_datasource.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginRemoteDatasourceImpl implements LoginRemoteDatasource {
  final http.Client client;
  LoginRemoteDatasourceImpl(this.client);

 final apiUrl = dotenv.env['API_URL'];

  @override
  Future<Map<String, dynamic>> login(String email, String senha) async {
    final response = await client.post(
      Uri.parse('$apiUrl/usuario/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha': senha}),
    );
    print('Response status: ${response.body}');
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return body;
    } else {
      throw (body['error'] ?? 'Erro ao fazer login');
    }
  }
}
