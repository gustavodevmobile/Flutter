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

// Método responsável por buscar as questões por disciplina selecionada,
// passa uma lista de disciplinas onde o método service.getQuestionsByDiscipline serializa para ser enviado ao backend
  void fetchQuestionsByDiscipline(
    List<String> disciplines,
    BuildContext context,
    Function(List<ModelQuestions>) onSuccess,
    Function(String) onError,
  ) async {
    try {
      List<ModelQuestions> questions =
          await service.getQuestionsByDiscipline(disciplines, context, (error) {
        onError(error);
      }, (isTimeout) {
        if (isTimeout) {
          print('Timeout: $isTimeout');
          isExpiredTimeout = true;
        }
      });
      onSuccess(questions);
    } catch (e) {
      onError('Ops, algo deu errado, tente novamente mais tarde');
    }
  }

// Método responsável por pegar os anos escolares da disciplina selecionada
// e retorna uma lista de anos escolares
  List<String> getSchoolYearInDisciplines(
      List<ModelQuestions> questionsByDisciplines) {
    Set<String> showListSchoolYears = {};
    for (var question in questionsByDisciplines) {
      showListSchoolYears.add(question.schoolYear);
    }
    return showListSchoolYears.toList()..sort();
  }

//Método responsável por pegar todas as disciplinas
  List<String> getDisciplinesContent(
      List<ModelQuestions> questionsByDisciplines) {
    disciplinesContent.clear();
    for (var question in questionsByDisciplines) {
      disciplinesContent.add(question.discipline);
    }
    return disciplinesContent.toList()..sort();
  }

// Método responsável por verificar se as disciplinas selecionadas constam nas disciplinas recebidas pelo método getDisciplinesContent
// e se não constar, exibe um snackbar informando que todas as questões daquela disciplina já foram respondidas
  void checkerDisciplines(List<String> listDisciplines, BuildContext context) {
    for (var dis in listDisciplines) {
      if (!disciplinesContent.contains(dis)) {
        showSnackBarFeedback(context,
            'Todas as questões de $dis já foram respondidas.', Colors.orange);
      }
    }
  }

// Método responsável por manipular a busca das questões por disciplina selecionada
  void handlerFetchQuestionsByDiscipline(
      BuildContext context, List<String> listDisciplines) {
    if (!isExpiredTimeout) {
      if (listDisciplines.isEmpty) {
        showSnackBarFeedback(
            context, 'Selecione uma disciplina para continuar.', Colors.blue);
      } else {
        // Exibe o loading dialog
        showLoadingDialog(context, 'Buscando questões...');
        // Passa a lista de disciplinas selecionadas para o método fetchQuestionsByDiscipline
        fetchQuestionsByDiscipline(listDisciplines, context, (questions) {
          if (questions.isNotEmpty) {
            // Fecha o loading dialog
            Navigator.pop(context);
            // Passa a lista de questões para a tela SchoolYears
            Routes().popRoutes(
              context,
              SchoolYears(
                questionsByDisciplines: questions,
                disciplines: getDisciplinesContent(questions),
                schoolYears: getSchoolYearInDisciplines(questions),
              ),
            );
            // Aqui vai verificar se as disciplinas selecionadas constam nas disciplinas recebidas pelo método getDisciplinesContent
            checkerDisciplines(listDisciplines, context);
          } else {
            if (!isExpiredTimeout) {
              showSnackBarFeedback(
                  context,
                  'Todas as questões desta(s) disciplina(s) já foram respondidas.',
                  Colors.blue);
              Navigator.pop(context);
            }
          }
        }, (errorMessage) {
          showSnackBarFeedback(context, errorMessage, Colors.red);
          Navigator.pop(context); // fecha o loading dialog
          Future.delayed(const Duration(seconds: 2), () {
            if (context.mounted) {
              Routes()
                  .popRoutes(context, const HomeScreen()); // fecha o snackbar
            }
          });
        });
      }
    }
  }
}
