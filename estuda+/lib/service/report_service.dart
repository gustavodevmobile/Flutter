import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:estudamais/models/user.dart';
import 'package:estudamais/shared_preference/storage_shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';

class ReportService {
  final String server = dotenv.env['server']!;
  final StorageSharedPreferences storageSharedPreferences =
      StorageSharedPreferences();
  final DateTime dateNow = DateTime.now().toUtc();

  Future<File> savePdfLocally(Uint8List pdfBytes, String fileName) async {
    // Obtém o diretório temporário para salvar o PDF
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';

    // Salva o PDF como um arquivo local
    final file = File(filePath);
    await file.writeAsBytes(pdfBytes);
    return file;
  }

  Future<void> sendReport(
    User user,
    String amountAnswered,
    List<Map<String, dynamic>> reportDataCorrects,
    String amountCorrects,
    List<Map<String, dynamic>> reportDataIncorrects,
    String amountIncorrects,
    //String email,
    //String timeResponse,
    Function(String) onSuccess,
    Function(String) onError,
  ) async {
    String date =
        '${dateNow.day.toString().padLeft(2, '0')}.${dateNow.month.toString().padLeft(2, '0')}.${dateNow.year}';
    try {
      final response = await http
          .post(
        Uri.parse('$server/report'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          {
            'userName': user.userName,
            'birthDate': user.birthDate,
            'schoolYear': user.schoolYear,
            'amountAnswered': amountAnswered,
            'reportDataCorrects': reportDataCorrects,
            'amountCorrects': amountCorrects,
            'reportDataIncorrects': reportDataIncorrects,
            'amountIncorrects': amountIncorrects,
            //'email': email, 
            //'time': timeResponse// Adiciona o e-mail ao corpo da requisição
          },
        ),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        return http.Response("Timeout", 408);
      });
      // print('reportDataCorrects $reportDataCorrects');

      if (response.statusCode == 200) {
        final file = await savePdfLocally(
            response.bodyBytes, '${user.userName}_${date}_relatorio.pdf');

        await storageSharedPreferences
            .saveReportToHistory(file.path, user.userName, (success) {
          //showSnackBarError(context, success, Colors.green);
        }, (error) {
          // showSnackBarError(context, error, Colors.red);
          print(error);
        });

        onSuccess('Relatório enviado e salvo com sucesso!');
      } else if (response.statusCode == 408) {
        onError('Tempo de espera excedido.\nTente novamente mais tarde.');
      } else {
        onError('Erro ao enviar relatório, ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      onError('Erro ao enviar relatório, $e');
    }
  }
}

//gucorrea.dev@outlook.com
