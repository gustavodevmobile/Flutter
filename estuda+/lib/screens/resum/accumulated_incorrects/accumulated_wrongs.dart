import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/models/model_questions.dart';
import 'package:estudamais/providers/global_providers.dart';
import 'package:estudamais/screens/home/home.dart';
import 'package:estudamais/screens/screen_questions/questions_incorrects.dart';
import 'package:estudamais/service/questions_incorrects_providers.dart';
import 'package:estudamais/service/service_resum_questions.dart';
import 'package:estudamais/theme/app_theme.dart';
import 'package:estudamais/widgets/background.dart';
import 'package:estudamais/widgets/button_next.dart';

import 'package:estudamais/screens/resum/widgets/disicipline_expansion_panel_radio.dart';

import 'package:estudamais/screens/resum/widgets/map_selected_scrollable.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccumulatedWrongs extends StatefulWidget {
  const AccumulatedWrongs({super.key});

  @override
  State<AccumulatedWrongs> createState() => _AccumulatedWrongsState();
}

class _AccumulatedWrongsState extends State<AccumulatedWrongs> {
  ServiceResumQuestions questionsIncorrects = ServiceResumQuestions();

  @override
  Widget build(BuildContext context) {
    return Consumer2<GlobalProviders, QuestionsIncorrectsProvider>(
      builder: (context, value, incorrects, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Respondidas incorretamente',
              style: AppTheme.customTextStyle()
            ),
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {
                
                Routes().popRoutes(context, const HomeScreen());
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
          body: Background(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Center(
                    child: Text(
                      'Assuntos selecionados:',
                      style: AppTheme.customTextStyle()
                    ),
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 400),
                    child: Visibility(
                      visible: value.showBoxSubjects,
                      child: MapSelectedDisciplines(
                        listMap: incorrects.subjectsAndSchoolYearSelected,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Divider(
                      color: Colors.black45,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Text(
                      'Selecione a disciplina e o assunto:',
                      style: AppTheme.customTextStyle()
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DisiciplineExpansionPanelRadio(
                        discipline:
                            questionsIncorrects.getDisciplineOfQuestions(
                                incorrects.resultQuestionsIncorrects),
                        resultQuestions: incorrects.resultQuestionsIncorrects,
                        activitySubjectsAndSchoolYearCorrects: false,
                        activitySubjectsAndSchoolYearIncorrects: true),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  //   child: ExpandedIncorrects(
                  //       discipline:
                  //           questionsIncorrects.getDisciplineOfQuestions(
                  //               incorrects.resultQuestionsIncorrects)),
                  // ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Divider(
                      color: Colors.black45,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      value.openBoxAlreadyAnswereds(false);
                      List<ModelQuestions> resultQuestionsIncorrects = [];
                      if (incorrects.subjectsAndSchoolYearSelected.isEmpty) {
                        showSnackBarError(
                          context,
                          'Selecione a disciplina e o assunto para continuar.',
                          Colors.red,
                        );
                      } else {
                        resultQuestionsIncorrects =
                            questionsIncorrects.getResultQuestions(
                                incorrects.resultQuestionsIncorrects,
                                incorrects.subjectsAndSchoolYearSelected);
                        Routes().pushRoute(
                            context,
                            PageQuestionsIncorrects(
                              resultQuestions: resultQuestionsIncorrects,
                            ));
                      }
                    },
                    child: const ButtonNext(textContent: 'Mostrar questões'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
