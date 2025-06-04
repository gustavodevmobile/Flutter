import 'dart:convert';
import 'package:blurt/models/abordagem_principal/aboradagem_principal.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AbordagemPrincipalDatasource {
  final http.Client client;
  AbordagemPrincipalDatasource(this.client);

  final apiUrl = dotenv.env['API_URL'];

  Future<List<AbordagemPrincipal>> buscarAbordagensPrincipais() async {
    final response = await client.get(
      Uri.parse('$apiUrl/abordagem-principal/aprovadas'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<AbordagemPrincipal> abordagens = (data as List)
          .map((item) => AbordagemPrincipal.fromJson(item))
          .toList();
      return abordagens;
    } else {
      throw Exception('Erro ao buscar abordagens principais');
    }
  }
}
