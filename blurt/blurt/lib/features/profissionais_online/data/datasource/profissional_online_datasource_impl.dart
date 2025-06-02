import 'package:blurt/features/profissionais_online/data/datasource/profissionais_online_datasoure.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// class ProfissionalOnlineDatasourceImpl  implements ProfissionaisOnlineDatasoure{
//   final http.Client client;
//   ProfissionalOnlineDatasourceImpl(this.client);
//   final apiUrl = dotenv.env['API_URL'];

  // @override
  // Future<List<Map<String, dynamic>> buscarProfissionaisOnline() async {
  //   final response = await client.get(
  //     Uri.parse('$apiiUrl/profissionais/online');
  //     headers: {'Content-Type': 'application/json'},
  //   );

  //   if (response.statusCode == 200) {
  //     // Supondo que a resposta seja uma lista de strings
  //     return List<String>.from(response.body);
  //   } else {
  //     throw Exception('Erro ao buscar profissionais online');
  //   }
  // }
//}