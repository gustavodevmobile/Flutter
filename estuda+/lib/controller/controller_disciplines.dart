import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/models/model_questions.dart';
import 'package:estudamais/screens/schoolYears/school_years.dart';
import 'package:estudamais/service/service.dart';
import 'package:estudamais/widgets/show_loading_dialog.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';

class ControllerDisciplines {
  Service service = Service();
  Set<String> disciplinesContent = {};

  void fetchQuestionsByDiscipline(
      List<String> disciplines,
      BuildContext context,
      Function(List<ModelQuestions>) onSuccess,
      Function(String) onError) async {
    try {
      List<ModelQuestions> questions =
          await service.getQuestionsByDiscipline(disciplines, context);
      onSuccess(questions);
    } catch (e) {
      onError('Ops, algo deu errado, tente novamente mais tarde');
    }
  }

  List<String> getSchoolYearInDisciplines(
      List<ModelQuestions> questionsByDisciplines) {
    Set<String> showListSchoolYears = {};
    for (var question in questionsByDisciplines) {
      showListSchoolYears.add(question.schoolYear);
    }
    return showListSchoolYears.toList()..sort();
  }

  List<String> getDisciplinesContent(
      List<ModelQuestions> questionsByDisciplines) {
    for (var question in questionsByDisciplines) {
      disciplinesContent.add(question.discipline);
    }
    return disciplinesContent.toList()..sort();
  }

  void checkerDisciplines(List<String> listDisciplines, BuildContext context) {
    for (var dis in listDisciplines) {
      if (!disciplinesContent.contains(dis)) {
        showSnackBarError(context,
            'Todas as questões de $dis já foram respondidas.', Colors.orange);
      }
    }
  }

  void handlerFetchQuestionsByDiscipline(
      BuildContext context, List<String> listDisciplines) {
    if (listDisciplines.isEmpty) {
      showSnackBarError(
          context, 'Selecione uma disciplina para continuar.', Colors.red);
    } else {
      showLoadingDialog(context, 'Buscando questões...');
      fetchQuestionsByDiscipline(listDisciplines, context, (questions) {
        if (questions.isNotEmpty) {
          Routes().popRoutes(
            context,
            SchoolYears(
              questionsByDisciplines: questions,
              disciplines: getDisciplinesContent(questions),
              schoolYears: getSchoolYearInDisciplines(questions),
            ),
          );
          checkerDisciplines(listDisciplines, context);
        } else {
          showSnackBarError(
              context,
              'Todas as questões desta(s) disciplina(s) já foram respondidas.',
              Colors.blue);
          Navigator.pop(context);
        }
      }, (errorMessage) {
        showSnackBarError(context, errorMessage, Colors.red);
        Navigator.pop(context);
      });
    }
  }
}
