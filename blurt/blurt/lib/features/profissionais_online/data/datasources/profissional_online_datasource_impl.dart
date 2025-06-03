import 'dart:convert';
import 'package:blurt/features/profissionais_online/data/datasources/profissionais_online_datasource.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProfissionalOnlineDatasourceImpl  implements ProfissionaisOnlineDatasoure{

  String apiiUrl = dotenv.env['API_URL']!;
  final http.Client client;
  ProfissionalOnlineDatasourceImpl(this.client);
  final apiUrl = dotenv.env['API_URL'];

  @override
  Future<List<Map<String, dynamic>>> buscarProfissionaisOnline() async {
    final response = await client.get(
      Uri.parse('$apiiUrl/profissionais/online'),
      headers: {'Content-Type': 'application/json'},
    );

    final body = jsonDecode(response.body);
   
    if (response.statusCode == 200) {
      return body.cast<Map<String, dynamic>>();
    } else {
      throw (body['error'] ?? 'Erro ao fazer login');
    }
  }
}