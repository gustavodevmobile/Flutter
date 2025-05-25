// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:http/http.dart' as http;
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// class ExplanationQuestionsService {
//   final String baseUrl = dotenv.env['server']!;

//   Future<String> explainQuestion({
//     required String question,
//     required List<String> alternatives,
//     Uint8List? image, // Imagem opcional
//   }) async {
//     try {
//       //Monta o corpo da requisição
//       final Map<String, dynamic> body = {
//         'question': question,
//         'alternatives': alternatives,
//       };

//       // String body =
//       //     "Explique a questão: $question. As alternativas são: ${alternatives.join(', ')} e responda com a alternativa correta.";

//       //Adiciona a imagem ao corpo, se existir
//       if (image != null) {
//         body['image'] = base64Encode(image); // Converte a imagem para Base64
//       }

//       print('Corpo da requisição: $body');
//       final response = await http.post(
//         Uri.parse('$baseUrl/explain-question'),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(body),
//       );

//       // Verifica o status da resposta
//       if (response.statusCode == 200) {
//         // Retorna o corpo da resposta como string
//         return response.body;
//       } else {
//         throw Exception(
//             'Erro ao explicar a questão: ${response.statusCode} - ${response.reasonPhrase}');
//       }
//     } catch (e) {
//       throw Exception('Erro na requisição: $e');
//     }
//   }
// }
