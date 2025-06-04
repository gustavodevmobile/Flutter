import 'dart:convert';
import 'package:blurt/models/temas_clinicos/temas_clinicos_models.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class TemasClinicosDatasource {
  final http.Client client;
  TemasClinicosDatasource(this.client);

  Future<List<TemasClinicos>> buscarTemasClinicos() async {
    final apiUrl = dotenv.env['API_URL'];
    final response = await client.get(
      Uri.parse('$apiUrl/temas-clinicos/aprovados'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<TemasClinicos> temasClinicos = (data as List)
          .map((item) => TemasClinicos.fromJson(item))
          .toList();
      return temasClinicos;
    } else {
      throw Exception('Erro ao buscar temas clínicos');
    }
  }
}
