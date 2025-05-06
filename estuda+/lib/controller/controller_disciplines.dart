import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/models/model_questions.dart';
import 'package:estudamais/screens/home/home.dart';
import 'package:estudamais/screens/schoolYears/school_years.dart';
import 'package:estudamais/service/service.dart';
import 'package:estudamais/widgets/show_loading_dialog.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';

// Classe resposnsável por fazer o controller na busca das disciplinas na screen discipline
class ControllerDisciplines {
  Service service = Service();
  Set<String> disciplinesContent = {};
  bool isExpiredTimeout = false;

// Método responsável por buscar os anos escolares por disciplina selecionada
  Future<List<String>> fetchSchoolYearByDiscipline(
      List<String> listDisciplines, BuildContext context) async {
    List<String> listSchoolYears =
        await service.fetchSchoolYearByDisciplines(listDisciplines, (error) {
      showSnackBarFeedback(context, error, Colors.red);
    });

    return listSchoolYears;
  }

// Método responsável por manipular a busca dos anos escolares por disciplina selecionada.
  void handlerFetchQuestionsByDiscipline(
      BuildContext context, List<String> listDisciplines) async {
    showLoadingDialog(context, 'Buscando questões...');
    // Chama o método fetchSchoolYearByDiscipline
    List<String> listSchoolYears =
        await fetchSchoolYearByDiscipline(listDisciplines, context);
    if (listSchoolYears.isNotEmpty) {
      if (context.mounted) {
        Routes().popRoutes(
          context,
          SchoolYears(
              disciplines: listDisciplines, schoolYears: listSchoolYears),
        );
      }
    }else{
      if (context.mounted) {
        showSnackBarFeedback(
            context, 'Nenhum ano escolar encontrado', Colors.orange);
      }
    }
  }
}
