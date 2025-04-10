import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ServiceFeedbacks {
 final String server = dotenv.env['server']!;

 Future<void> sendFeedback(String id)async{
  try{
    final jsonId = jsonEncode({
      'id': id,
    });
    final response = await http.post(
      Uri.parse('http://$server/feedback/$jsonId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
          'message': 'Feedback enviado com sucesso!',
        }),
      
    );
    if (response.statusCode == 200) {
      print('Feedback enviado com sucesso!');
    } else {
      print('Erro ao enviar feedback: ${response.statusCode}');
    }
  } catch (e) {
    print('Erro ao enviar feedback: $e');

  }
 }
}