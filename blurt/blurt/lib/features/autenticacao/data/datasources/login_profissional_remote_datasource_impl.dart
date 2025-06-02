import 'dart:convert';
import 'package:http/http.dart' as http;
import 'login_profissional_remote_datasource.dart';

class LoginProfissionalRemoteDatasourceImpl
    implements LoginProfissionalRemoteDatasource {
  final http.Client client;
  LoginProfissionalRemoteDatasourceImpl(this.client);

  @override
  Future<Map<String, dynamic>> login(String cpf, String senha) async {
    final response = await client.post(
      Uri.parse('https://suaapi.com/profissional/login'),
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
