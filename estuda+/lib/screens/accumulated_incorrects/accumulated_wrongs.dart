import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/models/model_questions.dart';
import 'package:estudamais/models/models.dart';
import 'package:estudamais/screens/home/home.dart';
import 'package:estudamais/screens/screen_questions/questions_incorrects.dart';
import 'package:estudamais/service/questions_incorrects_providers.dart';
import 'package:estudamais/service/service_questions_incorrects/questions_incorrets.dart';
import 'package:estudamais/service/service_resum_questions.dart';
import 'package:estudamais/widgets/background.dart';
import 'package:estudamais/widgets/button_next.dart';
import 'package:estudamais/screens/accumulated_incorrects/widgets/expanded_incorrects.dart';

import 'package:estudamais/widgets/map_selected_scrollable.dart';
import 'package:estudamais/widgets/show_snackBar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';

class AccumulatedWrongs extends StatefulWidget {
  const AccumulatedWrongs({super.key});

  @override
  State<AccumulatedWrongs> createState() => _AccumulatedWrongsState();
}

class _AccumulatedWrongsState extends State<AccumulatedWrongs> {
  bool checked = false;
  ServiceResumQuestions questionsIncorrects = ServiceResumQuestions();

  onChecked() {
    setState(() {
      checked = !checked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ModelPoints, QuestionsIncorrectsProvider>(
      builder: (context, value, incorrects, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Respondidas incorretamente',
              style: GoogleFonts.aboreto(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {
                //QuestionsCorrects.subjectsOfQuestionsCorrects.clear();
                //QuestionsIncorrects.subjectsOfQuestionsIncorrects.clear();
                Routes().popRoutes(context, const HomeScreen());
              },
              icon: const Icon(
                Icons.arrow_back,
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
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ExpandedIncorrects(
                      discipline: questionsIncorrects.getDisciplineOfQuestions(incorrects.resultQuestionsIncorrects)
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Divider(
                      color: Colors.black45,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                       List<ModelQuestions> resultQuestionsIncorrects = [];
                      if (incorrects.subjectsAndSchoolYearSelected.isEmpty) {
                        showSnackBar(
                          context,
                          'Selecione a disciplina e o assunto para continuar.',
                          Colors.red,
                        );
                      } else {
                        resultQuestionsIncorrects = questionsIncorrects.getResultQuestions(incorrects.resultQuestionsIncorrects, incorrects.subjectsAndSchoolYearSelected);
                        Routes().pushRoute(
                            context, PageQuestionsIncorrects(resultQuestions: resultQuestionsIncorrects,));
                        
                      }
                    },
                    child: const ButtonNext(textContent: 'Mostrar questões'),
                  ),
                ],
              ),
            ),
          ),
          // floatingActionButtonLocation:
          //     FloatingActionButtonLocation.centerFloat,
          // floatingActionButton: GestureDetector(
          //   onTap: () {
          //     if (QuestionsIncorrects.mapYearAndSubjectSelected.isEmpty) {
          //       showSnackBar(
          //         context,
          //         'Selecione a disciplina e o assunto para continuar.',
          //         Colors.red,
          //       );
          //     } else {
          //       Routes().pushRoute(context, const PageQuestionsIncorrects());
          //       QuestionsIncorrects().getResultQuestionsIncorrects();
          //     }
          //   },
          //   child: const ButtonNext(textContent: 'Mostrar questões'),
          // ),
        );
      },
    );
  }
}
