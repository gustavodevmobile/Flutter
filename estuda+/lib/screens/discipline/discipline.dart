import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/database/storage_shared_preferences.dart';
import 'package:estudamais/models/model_questions.dart';

import 'package:estudamais/screens/home/home.dart';
import 'package:estudamais/screens/schoolYears/school_years.dart';

import 'package:estudamais/service/service.dart';
import 'package:estudamais/widgets/animated_button_retangulare.dart';
import 'package:estudamais/widgets/background.dart';
import 'package:estudamais/widgets/button_next.dart';
import 'package:estudamais/widgets/show_loading_dialog.dart';
import 'package:estudamais/widgets/show_snackBar.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:estudamais/models/models.dart';

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
  double heightButtonNext = 0;
  List<String> listDisciplinesSelected = [];
  List<String> showListSchoolYears = [];

  StorageSharedPreferences sharedPreferences = StorageSharedPreferences();

  void fetchQuestionsByDiscipline(Function(List<ModelQuestions>) onSuccess,
      Function(String) onError) async {
    try {
      List<ModelQuestions> questions =
          await service.getQuestionsByDiscipline(listDisciplinesSelected);
      onSuccess(questions);
    } catch (e) {
      onError('Ops, algo deu errado, tente novamente mais tarde');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelPoints>(builder: (context, value, child) {
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
          title: Text(
            'Disciplinas',
            style: GoogleFonts.aboreto(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Stack(
          children: [
            Background(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Selecione a disciplina:',
                        style: GoogleFonts.aboreto(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
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
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.disciplines.length,
                        itemBuilder: (context, int index) {
                          return AnimatedButtonRectangular(
                            title: widget.disciplines[index],
                            fontSizeTitle: 22,
                            textDirection: MainAxisAlignment.center,
                            onTap: () {
                              if (value.actionBtnRetangulare) {
                                listDisciplinesSelected
                                    .add(widget.disciplines[index]);
                                heightButtonNext = 50;
                              } else {
                                listDisciplinesSelected
                                    .remove(widget.disciplines[index]);

                                heightButtonNext = 0;
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: GestureDetector(
          onTap: () async {
            if (listDisciplinesSelected.isEmpty) {
              showSnackBarError(context, 'Selecione uma disciplina para continuar.',
                  Colors.red);
            } else {
              showLoadingDialog(context, 'Buscando questões...');
              fetchQuestionsByDiscipline((questions) {
                if (!mounted) return;
                if (questions.isNotEmpty) {
                  for (var question in questions) {
                    showListSchoolYears.add(question.schoolYear);
                  }
                  Routes().popRoutes(
                    context,
                    SchoolYears(
                      questionsByDisciplines: questions,
                      disciplines: listDisciplinesSelected..sort(),
                      schoolYears: showListSchoolYears.toSet().toList()..sort(),
                    ),
                  );
                } else {
                  showSnackBarError(
                      context,
                      'Todas as questões desta disciplina já foram respondidas',
                      Colors.blue);
                  Navigator.pop(context);
                }
              }, (errorMessage) {
                if (!mounted) return;
                showSnackBarError(context, errorMessage, Colors.red);
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
