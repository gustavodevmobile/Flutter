import 'dart:convert';

import 'package:blurt/features/cadastro/data/datasources/usuario/cadastro_usuario_datasource.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class CadastroUsuarioDatasourceImpl implements CadastroUsuarioDatasource {
  final http.Client client;

  CadastroUsuarioDatasourceImpl(this.client);

  @override
  Future<String> cadastroUsuario(Map<String, dynamic> data) async {
    final apiUrl = dotenv.env['API_URL'];
    print(data);
    final response = await client.post(
      Uri.parse('$apiUrl/usuario'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      throw response.body;
    }
  }
}
