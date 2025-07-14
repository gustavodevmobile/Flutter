import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:noribox_store/models/produtos_models.dart';

class ProdutosService {
  Future<List<Produto>> buscarProdutos() async {
    final url = '${dotenv.env['API_URL']}/produtos/produtos';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      //print('Dados recebidos: $data');
      return data.map((json) => Produto.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar produtos');
    }
  }

  Future<String?> criarPreferenceId({
    required String nome,
    required double valor,
    required int quantidade,
  }) async {
    final url =
        Uri.parse('${dotenv.env['API_URL']}/pagamentos/criar-preference');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': nome,
        'preco': valor,
        'quantidade': quantidade,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data['preferenceId'] as String?;
    } else {
      print('Erro ao criar preference: ${response.body}');
      return null;
    }
  }

  
}
