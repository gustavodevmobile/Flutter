import 'package:estudamais/models/model_questions.dart';
import 'package:estudamais/service/service.dart';
import 'package:estudamais/shared_preference/storage_shared_preferences.dart';

class ControllerSubjects {
  Service service = Service();
  StorageSharedPreferences sharedPreference = StorageSharedPreferences();

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


        // Recupera os IDs das questões já respondidas do SharedPreferences
        List<String> answeredIds = await sharedPreference.recoverIds(
          StorageSharedPreferences.keyIdsAnswereds,
          (error) => onError('Erro ao recuperar IDs respondidos : $error'),
        );
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
