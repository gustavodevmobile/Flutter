import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ServiceFeedbacks {
  final String server = dotenv.env['server']!;

  Future<void> sendFeedback(String id, BuildContext context, List<String> feedbackOptions,
      Function(String) onSuccess, Function(String) onError) async {
    try {
      final response = await http.post(
        Uri.parse('http://$server/feedback'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'message': 'Foi reportado o(s) seguinte(s) erro(s) na questão id nº $id:',
          'descriptions': feedbackOptions,
        }),
      );
      if (response.statusCode == 200) {
        onSuccess(response.body);
      } else {
        onError('Erro ao enviar feedback: ${response.statusCode}');
      }
    } catch (e) {
     onError('Erro ao enviar feedback: $e');
    }
  }
}
