import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class CalcularFreteService {
  /// Calcula o frete para um destino específico com base nos produtos informados.
  ///
  /// [cepDestino] é o CEP de destino para o cálculo do frete.
  /// [products] é uma lista de mapas contendo os detalhes dos produtos,
  /// incluindo id, width, height, length e weight.
  ///
  /// Retorna um objeto JSON com o resultado do cálculo do frete.

  Future<List<Map<String, dynamic>>> calcularFrete({
    required String cepDestino,
    required List<Map<String, dynamic>>
        products, // Lista de produtos com id, width, height, length, weight
  }) async {
    final url = Uri.parse('${dotenv.env['API_URL']}/frete/calcular-frete');

    final body = {
      "toCep": cepDestino,
      "products": products,
    };

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      // Converta explicitamente para List<Map<String, dynamic>>
      return List<Map<String, dynamic>>.from(
        decoded.map((e) => Map<String, dynamic>.from(e)),
      );
    } else {
      print('Erro ao calcular frete: ${response.body}');
      throw Exception('Erro ao calcular frete');
    }
  }
}
