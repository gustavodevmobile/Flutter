import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/models/model_questions.dart';
import 'package:estudamais/providers/global_providers.dart';
import 'package:estudamais/screens/home/home.dart';
import 'package:estudamais/screens/resum/widgets/never_subjects_selected.dart';
import 'package:estudamais/screens/screen_questions/questions_corrects.dart';
import 'package:estudamais/service/questions_corrects_providers.dart';
import 'package:estudamais/service/service_resum_questions.dart';
import 'package:estudamais/theme/app_theme.dart';

import 'package:estudamais/widgets/background.dart';
import 'package:estudamais/widgets/button_next.dart';
import 'package:estudamais/screens/resum/widgets/disicipline_expansion_panel_radio.dart';

import 'package:estudamais/screens/resum/widgets/map_selected_scrollable.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class AccumulatedCorrects extends StatefulWidget {
  const AccumulatedCorrects({super.key});

  @override
  State<AccumulatedCorrects> createState() => _AccumulatedCorrectsState();
}

class _AccumulatedCorrectsState extends State<AccumulatedCorrects> {
  ServiceResumQuestions questionsCorrects = ServiceResumQuestions();
  ScrollController scrollController = ScrollController();
  //bool enable = false;
  ExpansionTileController? controleExpansion = ExpansionTileController();

  @override
  Widget build(BuildContext context) {
    return Consumer2<GlobalProviders, QuestionsCorrectsProvider>(
      builder: (context, value, corrects, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Respondidas corretamente',
                style: AppTheme.customTextStyle(fontSize: 15)),
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
                    child: Text('Assuntos selecionados:',
                        style: AppTheme.customTextStyle(
                            color: Colors.white, fontWeight: true)),
                  ),
                  // Widget que mostra os assuntos das disciplinas selecionadas.
                  corrects.subjectsAndSchoolYearSelected.isEmpty
                      ? const NeverSubjectsSelected()
                      : AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: Visibility(
                            visible: value.showBoxSubjects,
                            child: MapSelectedSubjects(
                              listMap: corrects.subjectsAndSchoolYearSelected,
                            ),
                          ),
                        ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Divider(
                      color: Colors.black45,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8.0),
                    child: Text('Selecione a disciplina e o assunto:',
                        style: AppTheme.customTextStyle(
                            color: Colors.white, fontWeight: true)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DisiciplineExpansionPanelRadio(
                      discipline: questionsCorrects.getDisciplineOfQuestions(
                          corrects.resultQuestionsCorrects),
                      resultQuestions: corrects.resultQuestionsCorrects,
                      activitySubjectsAndSchoolYearCorrects: true,
                      activitySubjectsAndSchoolYearIncorrects: false,
                    ),
                  ),

                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    child: Divider(
                      color: Colors.black45,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      List<ModelQuestions> resultQuestionsCorrects = [];
                      if (corrects.subjectsAndSchoolYearSelected.isEmpty) {
                        showSnackBarError(
                          context,
                          'Selecione a disciplina e o assunto para continuar.',
                          Colors.red,
                        );
                      } else {
                        resultQuestionsCorrects =
                            questionsCorrects.getResultQuestions(
                                corrects.resultQuestionsCorrects,
                                corrects.subjectsAndSchoolYearSelected);
                        Routes().pushRoute(
                            context,
                            PageQuestionsCorrects(
                              resultQuestions: resultQuestionsCorrects,
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
