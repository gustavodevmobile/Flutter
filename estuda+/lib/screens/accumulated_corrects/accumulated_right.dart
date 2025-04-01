import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/models/model_questions.dart';
import 'package:estudamais/models/models.dart';
import 'package:estudamais/screens/home/home.dart';
import 'package:estudamais/screens/screen_questions/questions_corrects.dart';
import 'package:estudamais/service/questions_corrects_providers.dart';
import 'package:estudamais/service/service_resum_questions.dart';

import 'package:estudamais/widgets/background.dart';
import 'package:estudamais/widgets/button_next.dart';
import 'package:estudamais/screens/accumulated_corrects/widgets/expanded_corrects.dart';

import 'package:estudamais/widgets/map_selected_scrollable.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';

class AccumulatedRight extends StatefulWidget {
  //final List<ModelQuestions> questionsCorrects;
  const AccumulatedRight({super.key});

  @override
  State<AccumulatedRight> createState() => _AccumulatedRightState();
}

class _AccumulatedRightState extends State<AccumulatedRight> {
  ServiceResumQuestions questionsCorrects = ServiceResumQuestions();
  ScrollController scrollController = ScrollController();
  //bool enable = false;
  ExpansionTileController? controleExpansion = ExpansionTileController();

  @override
  Widget build(BuildContext context) {
    return Consumer2<ModelPoints, QuestionsCorrectsProvider>(
      builder: (context, value, corrects, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Respondidas corretamente',
              style: GoogleFonts.aboreto(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
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
                      style: GoogleFonts.aboreto(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    child: Visibility(
                      visible: value.showBoxSubjects,
                      child: MapSelectedDisciplines(
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
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: ExpandedCorrects(
                      discipline:
                          questionsCorrects.getDisciplineOfQuestions(
                              corrects.resultQuestionsCorrects),
                      resultQuestions: corrects.resultQuestionsCorrects,
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
