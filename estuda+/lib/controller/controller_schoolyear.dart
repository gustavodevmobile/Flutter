import 'dart:convert';

import 'package:estudamais/service/service.dart';
import 'package:estudamais/shared_preference/storage_shared_preferences.dart';
import 'package:estudamais/storage_sqllite/storage_sqflite.dart';

/// Classe responsável por fazer o controller na busca dos assuntos com disciplinas e anos na screen subjects
class ControllerSchoolyear {
  Service service = Service();
  Set<String> disciplinesContent = {};
  bool isExpiredTimeout = false;
  StorageSqflite storageSqflite = StorageSqflite();

//Método responsável por buscar os assuntos... por disciplinas e ao anos selecionada
  Future<List<Map<String, dynamic>>> fetchSubjects(List<String> listDisciplines,
      List<String> listSchoolYear, Function(String) onError) async {
    List<Map<String, dynamic>> listMapSubjectsAndDisciplinesAndSchoolYear = [];

    try {
      listMapSubjectsAndDisciplinesAndSchoolYear = await service
          .fetchSubjectsByDisciplineAndSchoolYear(
              listDisciplines, listSchoolYear, (error) {
        onError(error);
      });
    } catch (e) {
      onError('Erro ao buscar assuntos: fetchSubjects $e');
    }

    return listMapSubjectsAndDisciplinesAndSchoolYear;
  }

// Método responsável por manipular a busca dos assuntos.
  Future<void> handlerFetchSubjects(
      List<String> listDisciplines,
      List<String> listSchoolYears,
      Function(List<Map<String, dynamic>>) response,
      Function(String) onError) async {
    List<Map<String, dynamic>> filteredList = [];
    List<Map<String, dynamic>> listSubjects = [];
    Map<String, dynamic> mapSubjects = {};
    try {
      List<Map<String, dynamic>> listMapSubjects =
          await fetchSubjects(listDisciplines, listSchoolYears, (error) {
        onError(error);
      });
      if (listMapSubjects.isNotEmpty) {
        // Recupera os IDs das questões já respondidas do SharedPreferences
        List<String> answeredCorrectsIds = await storageSqflite
            .getSavedQuestionIds(StorageSqflite.tableQuestionsCorrects);

        // Recupera os IDs das questões já respondidas incorretamente do SharedPreferences
        List<String> answeredIncorrectsIds = await storageSqflite
            .getSavedQuestionIds(StorageSqflite.tableQuestionsIncorrects);

        // Junta os IDs respondidos corretamente e incorretamente
        List<String> answeredIds = answeredIncorrectsIds + answeredCorrectsIds;

        // Filtra os assuntos removendo os que já foram respondidos
        filteredList = listMapSubjects.where((subject) {
          // Verifica se o ID do assunto não está na lista de IDs respondidos
          return !answeredIds.contains(subject['id'].toString());
        }).toList();

        print('Assuntos filtrados: $filteredList');

        Set<String> listSet = {};
        // Cria uma Objeto sem os ids
        for (var obj in filteredList) {
          mapSubjects = {
            'subject': obj['subject'],
            'schoolYear': obj['schoolYear'],
            'discipline': obj['discipline'],
          };
          // Adiciona os objetos ao Set para retirar os duplicados
          listSet.add(jsonEncode(mapSubjects));
        }
        // Converte o Set de volta para uma lista de Map<String, dynamic>
        for (var el in listSet) {
          listSubjects.add(json.decode(el));
        }

        // Ordena a lista pelo campo 'schoolYear'
        listSubjects.sort((a, b) {
          return a['schoolYear'].compareTo(b['schoolYear']);
        });
        //print('listSubjects: $listSubjects');
        response(listSubjects);
      } else {
        onError('Nenhum assunto encontrado: handlerFetchSubjects');
      }

      // Recupera os IDs das questões já respondidas do SharedPreferences
    } catch (e) {
      onError('Erro ao buscar assuntos: handlerFetchSubjects $e');
    }
  }
}
