import 'package:estudamais/models/model_questions.dart';
import 'package:estudamais/service/service.dart';

class ControllerSubjects {
  Service service = Service();

  Future<void> handlerFetchQuestions(
      List<Map<String, dynamic>> listMapSubjectsAndSchoolYear,
      Function(List<ModelQuestions>) questions,
      Function(String) onError) async {
    List<ModelQuestions> listQuestions = [];
    try {
      listQuestions = await service.fetchQuestions(listMapSubjectsAndSchoolYear, (error) {
        onError(error);
      });
      if(listQuestions.isNotEmpty) {
        questions(listQuestions);
      } else {
        onError('Nenhuma questão encontrada: handlerFetchQuestions');
      }
    } catch (e) {
      onError('Erro ao buscar questões: handlerFetchQuestions $e');
    }
  }
}
