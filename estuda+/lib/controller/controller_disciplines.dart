import 'package:estudamais/service/service.dart';
import 'package:estudamais/shared_preference/storage_shared_preferences.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';

// Classe resposnsável por fazer o controller na busca dos anos escolares por disciplina selecionada.
// Ela é responsável por manipular os dados e fazer a comunicação entre a view e o service.
class ControllerDisciplines {
  Service service = Service();
  Set<String> disciplinesContent = {};
  bool isExpiredTimeout = false;
  StorageSharedPreferences sharedPreferences = StorageSharedPreferences();

// Método responsável por buscar os anos escolares por disciplina selecionada, atraves do service.fetchSchoolYearByDisciplines e retornar uma lista de Map<String, dynamic> com os anos escolares.
  Future<List<Map<String, dynamic>>> fetchSchoolYearByDiscipline(
      List<String> listDisciplines,
      BuildContext context,
      Function(String) onError) async {
    List<Map<String, dynamic>> listSchoolYears = [];
    try {
      listSchoolYears =
          await service.fetchSchoolYearByDisciplines(listDisciplines, (error) {
        showSnackBarFeedback(context, error, Colors.red);
      });
    } catch (e) {
      onError('Erro ao buscar anos escolares: fetchSchoolYearByDiscipline $e');
    }

    return listSchoolYears;
  }

// Método responsável por manipular a busca dos anos escolares por disciplina selecionada.
  void handlerFetchSchoolYear(
      BuildContext context,
      List<String> listDisciplines,
      Function(List<String>) response,
      Function(String) onError) async {
    List<String> listSchoolYears = [];
    List<Map<String, dynamic>> filteredList = [];
    try {
      List<Map<String, dynamic>> idsAndSchooYear =
          await fetchSchoolYearByDiscipline(listDisciplines, context, (error) {
        onError(error);
      });
      if (idsAndSchooYear.isNotEmpty) {
        // Recupera os IDs das questões já respondidas do SharedPreferences
        List<String> answeredIds = await sharedPreferences.recoverIds(
          StorageSharedPreferences.keyIdsAnswereds,
          (error) => onError('Erro ao recuperar IDs respondidos : $error'),
        );
        
      // Filtra os anos escolares removendo os que já foram respondidos
        filteredList = idsAndSchooYear.where((subject) {
          // Verifica se o ID do assunto não está na lista de IDs respondidos
          return !answeredIds.contains(subject['id'].toString());
        }).toList();

        // Cria uma lista com os anos escolares filtrados
        for (var year in filteredList) {
          listSchoolYears.add(year['schoolYear']);
        }
        // Remove os anos escolares duplicados e ordena a lista
        response(listSchoolYears.toSet().toList()..sort());
      } else {
        onError('Nenhum ano escolar encontrado');
      }
    } catch (e) {
      onError('Erro ao buscar anos escolares: handlerFetchSchoolYear $e');
    }
  }
}
