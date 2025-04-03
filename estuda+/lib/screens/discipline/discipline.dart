import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/screens/discipline/widget/discipline_list.dart';
import 'package:estudamais/shared_preference/storage_shared_preferences.dart';
import 'package:estudamais/models/model_questions.dart';

import 'package:estudamais/screens/home/home.dart';
import 'package:estudamais/screens/schoolYears/school_years.dart';

import 'package:estudamais/service/service.dart';
import 'package:estudamais/theme/app_theme.dart';
import 'package:estudamais/widgets/animated_button_retangulare.dart';
import 'package:estudamais/widgets/background.dart';
import 'package:estudamais/widgets/button_next.dart';
import 'package:estudamais/widgets/show_loading_dialog.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';

import 'package:flutter/material.dart';
import 'package:estudamais/providers/global_providers.dart';

import 'package:provider/provider.dart';
//import 'package:progress_button/progress_button.dart';

class Discipline extends StatefulWidget {
  final List<String> disciplines;
  const Discipline({required this.disciplines, super.key});

  @override
  State<Discipline> createState() => _DisciplineState();
}

class _DisciplineState extends State<Discipline> {
  Color? colorFindError;
  String? textFindError;
  bool enable = false;
  Service service = Service();
  //double heightButtonNext = 0;
  List<String> listDisciplinesSelected = [];
  List<String> showListSchoolYears = [];

  StorageSharedPreferences sharedPreferences = StorageSharedPreferences();

  void fetchQuestionsByDiscipline(Function(List<ModelQuestions>) onSuccess,
      Function(String) onError) async {
    try {
      List<ModelQuestions> questions = await service.getQuestionsByDiscipline(
          listDisciplinesSelected, context);
      onSuccess(questions);
    } catch (e) {
      onError('Ops, algo deu errado, tente novamente mais tarde');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProviders>(builder: (context, value, child) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                Routes().popRoutes(context, const HomeScreen());
                //Service.questionsByDiscipline.clear();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
          title: Text('Disciplinas',
              style: AppTheme.customTextStyle(fontSize: 16)),
        ),
        body: Background(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Selecione a disciplina:',
                    style: AppTheme.customTextStyle(fontSize: 20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    padding: const EdgeInsets.only(top: 8, bottom: 20),
                    decoration: BoxDecoration(
                        color: Colors.white38,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            offset: Offset(0, 3),
                            blurRadius: 5,
                            color: Colors.black38,
                          )
                        ]),
                    child: DisciplineList(
                      disciplines: widget.disciplines,
                      onDisciplineTap: (discipline) {
                        if (value.actionBtnRetangulare) {
                          listDisciplinesSelected.add(
                            discipline,
                          );
                        } else {
                          listDisciplinesSelected.remove(
                            discipline,
                          );
                        }
                      },
                    )),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: GestureDetector(
          onTap: () async {
            List<String> disciplinesContent = [];
            if (listDisciplinesSelected.isEmpty) {
              showSnackBarError(context,
                  'Selecione uma disciplina para continuar.', Colors.red);
            } else {
              showLoadingDialog(context, 'Buscando questões...');
              fetchQuestionsByDiscipline((questions) {
                if (questions.isNotEmpty) {
                  for (var question in questions) {
                    showListSchoolYears.add(question.schoolYear);
                    disciplinesContent.add(question.discipline);
                  }
                  if (!mounted) return;
                  Routes().popRoutes(
                    context,
                    SchoolYears(
                      questionsByDisciplines: questions,
                      disciplines: disciplinesContent.toSet().toList()..sort(),
                      schoolYears: showListSchoolYears.toSet().toList()..sort(),
                    ),
                  );
                  for (var dis in listDisciplinesSelected) {
                    if (!disciplinesContent.contains(dis)) {
                      showSnackBarError(
                          context,
                          'Todas as questões de $dis já foram respondidas.',
                          Colors.orange);
                    }
                  }
                } else {
                  showSnackBarError(
                      context,
                      'Todas as questões desta(s) disciplina(s) já foram respondidas.',
                      Colors.blue);
                  Navigator.pop(context);
                }
              }, (errorMessage) {
                if (!mounted) return;
                showSnackBarError(context, errorMessage, Colors.red);
                Navigator.pop(context);
              });
            }
          },
          child: const ButtonNext(
            textContent: 'Buscar Questões',
          ),
        ),
      );
    });
  }
}
