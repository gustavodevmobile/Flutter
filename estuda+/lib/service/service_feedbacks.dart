import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// This class is responsible for sending feedback to the server.
class ServiceFeedbacks {
  final String server = dotenv.env['server']!;

  // This method sends feedback about failures in the app.
  Future<void> sendFeedbackFailures(String id, List<String> feedbackOptions,
      Function(String) onSuccess, Function(String) onError) async {
    try {
      final response = await http
          .post(
        Uri.parse('$server/feedback'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'message':
              'Foi reportado o(s) seguinte(s) erro(s) na questão id nº $id:',
          'descriptions': feedbackOptions,
        }),
      )
          .timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          return http.Response("Timeout", 408);
        },
      );
      if (response.statusCode == 200) {
        onSuccess(response.body);
      } else if (response.statusCode == 408) {
        onError('Tempo de espera excedido.\nTente novamente mais tarde.');
      } else {
        onError('Erro ao enviar feedback de falhas: ${response.statusCode}');
      }
    } catch (e) {
      onError('Erro ao enviar feedback de falhas: $e');
    }
  }

  // This method sends feedback about the app itself.
  Future<void> sendFeedbackApp(String message, Function(String) onSuccess,
      Function(String) onError) async {
    try {
      final response = await http
          .post(
        Uri.parse('$server/feedback-app'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'message': message,
        }),
      )
          .timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          return http.Response("Timeout", 408);
        },
      );
      if (response.statusCode == 200) {
        onSuccess(response.body);
      } else if (response.statusCode == 408) {
        onError('Tempo de espera excedido.\nTente novamente mais tarde.');
      } else {
        onError('Erro ao enviar feedback do app: ${response.statusCode}');
      }
    } catch (e) {
      onError('Erro ao enviar feedback do app: $e');
    }
  }
}
