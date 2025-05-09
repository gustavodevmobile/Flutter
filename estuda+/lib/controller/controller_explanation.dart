import 'dart:typed_data';
import 'package:estudamais/service/expanation_questions.dart';


class ExplanationQuestionsController {
  final ExplanationQuestionsService _service = ExplanationQuestionsService();

  Future<void> handleExplainQuestion({
    required String question,
    required List<String> alternatives,
    Uint8List? image, // Imagem opcional
    required Function(String) onSuccess, // Callback para sucesso
    required Function(String) onError, // Callback para erro
  }) async {
    try {
      // Chama o serviço para explicar a questão
      final explanation = await _service.explainQuestion(
        question: question,
        alternatives: alternatives,
        image: image,
      );

      // Chama o callback de sucesso com a explicação
      onSuccess(explanation);
    } catch (e) {
      // Mostra um feedback de erro ao usuário
      onError('Erro ao obter explicação da questão: $e');
      print('Erro ao obter explicação: $e');
    }
  }
}
