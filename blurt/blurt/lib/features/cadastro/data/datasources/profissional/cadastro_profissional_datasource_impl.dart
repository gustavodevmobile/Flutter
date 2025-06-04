import 'dart:convert';
import 'package:blurt/features/cadastro/data/datasources/profissional/cadastro_profissional_datasource.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class CadastroProfissionalDatasourceImpl
    implements CadastroProfissionalDatasource {
  final http.Client client;
  CadastroProfissionalDatasourceImpl(this.client);

  final apiUrl = dotenv.env['API_URL'];
  @override
  Future<String> cadastrarProfissional(
      Map<String, dynamic> data) async {
    final response = await client.post(
      Uri.parse('$apiUrl/profissional'),
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
