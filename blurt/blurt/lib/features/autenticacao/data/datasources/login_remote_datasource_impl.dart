import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../shared/usuario/usuario_model.dart';
import 'login_remote_datasource.dart';

class LoginRemoteDatasourceImpl implements LoginRemoteDatasource {
  final http.Client client;
  LoginRemoteDatasourceImpl(this.client);

  static const String _baseUrl = 'http://10.0.2.2:3000';

  @override
  Future<Map<String, dynamic>> login(String email, String senha) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/usuario/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha': senha}),
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return body;
    } else {
      throw (body['error'] ?? 'Erro ao fazer login');
    }
  }
}
