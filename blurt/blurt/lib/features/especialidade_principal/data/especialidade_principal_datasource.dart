import 'dart:convert';
import 'package:blurt/models/especialidade_principal/especialidade_principal.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EspecialidadePrincipalDatasource {
  final http.Client client;
  EspecialidadePrincipalDatasource( this.client);

  final apiUrl = dotenv.env['API_URL'];

  Future<List<EspecialidadePrincipal>> buscarEspecialidadesPrincipais() async {
    final response = await client.get(
      Uri.parse('$apiUrl/especialidade-principal/aprovadas'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<EspecialidadePrincipal> especialidades = (data as List)
          .map((item) => EspecialidadePrincipal.fromJson(item))
          .toList();
      return especialidades;
    } else {
      print('Erro ao buscar especialidades principais: ${response.statusCode}');
      throw Exception('Erro ao buscar especialidades principais');
    }
  }
}
