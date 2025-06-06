import 'dart:convert';
import 'package:blurt/features/dashboards/profissional/data/datasources/dashboard_profissional_datasource.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DashboardProfissionalDatasourceImpl
    implements DashboardProfissionalDatasource {
  final http.Client client;

  DashboardProfissionalDatasourceImpl(this.client);

  @override
  Future<List<Map<String, dynamic>>> buscarSessoes(String userId) async {
    final apiUrl = dotenv.env['API_URL'];
    final url = Uri.parse('$apiUrl/profissional/sessoes/$userId');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Erro ao buscar sessões: ${response.statusCode}');
    }
  }

  @override
  Future<String> alterarStatusAtendePlantao({
    required String profissionalId,
    required bool novoStatus,
  }) async {
    final apiUrl = dotenv.env['API_URL'];
    final url = Uri.parse('$apiUrl/profissional/atende-plantao');
    final response = await client.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': profissionalId,
        'atendePlantao': novoStatus,
      }),
    );

    print(response.body);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception(
          'Erro ao alterar status de atendimento: ${response.statusCode}');
    }
  }

  @override
  Future<String> logoutProfissional({
    required String profissionalId,
  }) async {
    final apiUrl = dotenv.env['API_URL'];
    final url = Uri.parse('$apiUrl/profissional/offline');
    final response = await client.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id': profissionalId}),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Erro ao fazer logout: ${response.statusCode}');
    }
  }
}
