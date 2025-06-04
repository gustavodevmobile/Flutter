import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:blurt/models/abordagens_utilizadas/abordagens_utilizadas.dart';

class AbordagensUtilizadasDatasource {
  final http.Client client;
  AbordagensUtilizadasDatasource(this.client);

  Future<List<AbordagensUtilizadas>> buscarAbordagensUtilizadas() async {
    final apiUrl = dotenv.env['API_URL'];
    final response = await client.get(
      Uri.parse('$apiUrl/abordagens-utilizadas/aprovadas'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<AbordagensUtilizadas> abordagensUtilizadas = (data as List)
          .map((item) => AbordagensUtilizadas.fromJson(item))
          .toList();
      return abordagensUtilizadas;
    } else {
      throw Exception('Erro ao buscar abordagens utilizadas');
    }
  }
}
