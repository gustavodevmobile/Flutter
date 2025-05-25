import 'package:estudamais/models/model_questions.dart';
import 'package:estudamais/service/service.dart';
import 'package:estudamais/shared_preference/storage_shared_preferences.dart';
import 'package:estudamais/storage_sqllite/storage_sqflite.dart';

class ControllerSubjects {
  Service service = Service();

  StorageSqflite storageSqflite = StorageSqflite();

  Future<void> handlerFetchQuestions(
      List<Map<String, dynamic>> listMapSubjectsAndSchoolYear,
      Function(List<ModelQuestions>) questions,
      Function(String) onError) async {
    List<ModelQuestions> listQuestions = [];
    try {
      listQuestions =
          await service.fetchQuestions(listMapSubjectsAndSchoolYear, (error) {
        onError(error);
      });
      if (listQuestions.isNotEmpty) {
        // Recupera os IDs das questões já respondidas do SharedPreferences
        List<String> answeredCorrectsIds = await storageSqflite
            .getSavedQuestionIds(StorageSqflite.tableQuestionsCorrects);

        // Recupera os IDs das questões já respondidas incorretamente do SharedPreferences
        List<String> answeredIncorrectsIds = await storageSqflite
            .getSavedQuestionIds(StorageSqflite.tableQuestionsIncorrects);

        // Junta os IDs respondidos corretamente e incorretamente
        List<String> answeredIds = answeredIncorrectsIds + answeredCorrectsIds;
        print('IDs respondidos: $answeredIds');
        // Filtra as questões removendo as que já foram respondidas
        listQuestions = listQuestions.where((question) {
          // Verifica se o ID da questão não está na lista de IDs respondidos
          return !answeredIds.contains(question.id.toString());
        }).toList();

        print('Questões filtradas: $listQuestions');
        questions(listQuestions);
      } else {
        onError('Nenhuma questão encontrada: handlerFetchQuestions');
      }
    } catch (e) {
      onError('Erro ao buscar questões: handlerFetchQuestions $e');
    }
  }
}
