// import 'dart:typed_data';
// import 'package:estudamais/service/expanation_questions.dart';
// import 'dart:convert';

// class ExplanationQuestionsController {
//   final ExplanationQuestionsService _service = ExplanationQuestionsService();

//   String formatExplanation(String jsonResponse) {
//   try {
//     // Converte a string JSON em um mapa
//     final Map<String, dynamic> data = jsonDecode(jsonResponse);

//     // Verifica se o campo 'choices' existe e não é nulo
//     if (data['choices'] == null || data['choices'].isEmpty) {
//       return 'Erro: Nenhuma explicação encontrada na resposta.';
//     }

//     // Verifica se o campo 'message' e 'content' existem
//     final message = data['choices'][0]['message'];
//     if (message == null || message['content'] == null) {
//       return 'Erro: O conteúdo da explicação está ausente.';
//     }

//     // Extrai o conteúdo da explicação
//     final String explanation = message['content'];
//     return explanation;
//   } catch (e) {
//     // Retorna uma mensagem de erro caso o JSON seja inválido
//     return 'Erro ao processar a explicação: $e';
//   }
// }

//   Future<void> handleExplainQuestion({
//     required String question,
//     required List<String> alternatives,
//     Uint8List? image, // Imagem opcional
//     required Function(String) onSuccess, // Callback para sucesso
//     required Function(String) onError, // Callback para erro
//   }) async {
//     try {
//       // Chama o serviço para explicar a questão
//       final explanation = await _service.explainQuestion(
//         question: question,
//         alternatives: alternatives,
//         image: image,
//       );
//       //final formattedExplanation = formatExplanation(explanation);

//       print('Explicação recebida: $explanation');
//       onSuccess(explanation);
//     } catch (e) {
//       // Mostra um feedback de erro ao usuário
//       onError('Erro ao obter explicação da questão: $e');
//       print('Erro ao obter explicação: $e');
//     }
//   }
// }
