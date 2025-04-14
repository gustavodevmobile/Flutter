import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ReportService {
  final String server = dotenv.env['server']!;

  Future<void> sendReport(
      List<Map<String, dynamic>> reportDataCorrects,
      String amountCorrects,
      List<Map<String, dynamic>> reportDataIncorrects,
      String amountIncorrects,
      String email,
      Function(String) onSuccess,
      Function(String) onError) async {
    try {
      final response = await http.post(
        Uri.parse('http://$server/report'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'reportDataCorrects': reportDataCorrects,
          'amountCorrects': amountCorrects,
          'reportDataIncorrects': reportDataIncorrects,
          'amountIncorrects': amountIncorrects,
          'email': email, // Adiciona o e-mail ao corpo da requisição
        }),
      );

      if (response.statusCode == 200) {
        onSuccess(response.body);
      } else {
        onError('Erro ao enviar relatório, ${response.statusCode}');
      }
    } catch (e) {
      onError('Erro ao enviar relatório, $e');
    }
  }
}

//gucorrea.dev@outlook.com
