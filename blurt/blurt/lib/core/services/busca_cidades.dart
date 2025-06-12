import 'package:http/http.dart' as http;
import 'dart:convert';

class LocalidadesService {
  static const String _baseUrl = 'https://servicodados.ibge.gov.br/api/v1/localidades';

  // Função para buscar cidades por estado
  Future<List<String>> buscarCidadesPorEstado(String uf) async {
    final url = '$_baseUrl/estados/$uf/municipios';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map<String>((cidade) => cidade['nome'] as String).toList();
    } else {
      throw Exception('Erro ao buscar cidades');
    }
  }
}