import 'dart:convert';
import 'package:estudamais/models/user.dart';
import 'package:estudamais/shared_preference/storage_shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ReportService {
  final String server = dotenv.env['server']!;
  final StorageSharedPreferences storageSharedPreferences =
      StorageSharedPreferences();

  Future<void> sendReport(
      User user,
      String amountAnswered,
      List<Map<String, dynamic>> reportDataCorrects,
      String amountCorrects,
      List<Map<String, dynamic>> reportDataIncorrects,
      String amountIncorrects,
      String email,
      Function(String) onSuccess,
      Function(String) onError) async {
    try {
      final response = await http.post(
        Uri.parse('$server/report'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userName': user.userName,
          'birthDate': user.birthDate,
          'schoolYear': user.schoolYear,
          'amountAnswered': amountAnswered,
          'reportDataCorrects': reportDataCorrects,
          'amountCorrects': amountCorrects,
          'reportDataIncorrects': reportDataIncorrects,
          'amountIncorrects': amountIncorrects,
          'email': email, // Adiciona o e-mail ao corpo da requisição
        }),
      );
      print('reportDataCorrects $reportDataCorrects');

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
