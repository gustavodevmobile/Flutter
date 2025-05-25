import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/models/model_questions.dart';
import 'package:estudamais/providers/global_providers.dart';
import 'package:estudamais/screens/home/home.dart';
import 'package:estudamais/screens/resum/widgets/never_subjects_selected.dart';
import 'package:estudamais/screens/resum/incorrects/questions_incorrects.dart';
import 'package:estudamais/service/service_resum_questions.dart';
import 'package:estudamais/shared_preference/storage_shared_preferences.dart';
import 'package:estudamais/theme/app_theme.dart';
import 'package:estudamais/widgets/background.dart';
import 'package:estudamais/widgets/button_next.dart';

import 'package:estudamais/screens/resum/widgets/disicipline_expansion_panel_radio.dart';

import 'package:estudamais/screens/resum/widgets/map_selected_scrollable.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccumulatedIncorrects extends StatefulWidget {
  const AccumulatedIncorrects({super.key});

  @override
  State<AccumulatedIncorrects> createState() => _AccumulatedIncorrectsState();
}

class _AccumulatedIncorrectsState extends State<AccumulatedIncorrects> {
  ServiceResumQuestions questionsIncorrects = ServiceResumQuestions();
  StorageSharedPreferences storageSharedPreferences =
      StorageSharedPreferences();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Consumer<GlobalProviders>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Respondidas incorretamente',
              style: AppTheme.customTextStyle(fontSize: screenWidth * 0.035),
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
                      style: AppTheme.customTextStyle(
                          fontWeight: true, fontSize: screenWidth * 0.04),
                    ),
                  ),
                  value.subjectsAndSchoolYearSelected.isEmpty
                      ? const NeverSubjectsSelected()
                      : AnimatedSize(
                          duration: const Duration(milliseconds: 400),
                          child: Visibility(
                            visible: value.showBoxSubjects,
                            child: MapSelectedSubjects(
                              listMap:
                                  value.subjectsAndSchoolYearSelected,
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
                    child: Text('Selecione a disciplina e o assunto:',
                        style: AppTheme.customTextStyle(
                            fontWeight: true, fontSize: screenWidth * 0.03)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DisiciplineExpansionPanelRadio(
                      discipline: questionsIncorrects.getDisciplineOfQuestions(
                          value.resultQuestionsIncorrects),
                      resultQuestions: value.resultQuestionsIncorrects,
                      activitySubjectsAndSchoolYearCorrects: false,
                      activitySubjectsAndSchoolYearIncorrects: true,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Divider(
                      color: Colors.black45,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      value.openBoxAlreadyAnswereds(false);
                      List<ModelQuestions> resultQuestionsIncorrects = [];
                      if (value.subjectsAndSchoolYearSelected.isEmpty) {
                        showSnackBarFeedback(
                          context,
                          'Selecione a disciplina e o assunto para continuar.',
                          Colors.red,
                        );
                      } else {
                        resultQuestionsIncorrects = questionsIncorrects
                            .getResultQuestions(
                                value.resultQuestionsIncorrects,
                                value.subjectsAndSchoolYearSelected,
                                (error) {
                          showSnackBarFeedback(context, error, Colors.red);
                        });
                        Routes().pushRoute(
                          context,
                          PageQuestionsIncorrects(
                            resultQuestions: resultQuestionsIncorrects,
                          ),
                        );
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
