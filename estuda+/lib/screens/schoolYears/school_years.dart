import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/models/model_questions.dart';
import 'package:estudamais/screens/home/home.dart';
import 'package:estudamais/screens/schoolYears/widgets/animated_button_circle.dart';
import 'package:estudamais/screens/subjects/subjects.dart';
import 'package:estudamais/service/service.dart';
import 'package:estudamais/widgets/background.dart';
import 'package:estudamais/widgets/button_next.dart';
import 'package:estudamais/widgets/list_selected_scrollable.dart';
import 'package:estudamais/widgets/show_snackBar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:estudamais/models/models.dart';
import 'package:provider/provider.dart';
//import 'package:progress_button/progress_button.dart';

class SchoolYears extends StatefulWidget {
  final List<ModelQuestions> questionsByDisciplines;
  final List<String> disciplines;
  final List<String> schoolYears;
  const SchoolYears(
      {required this.questionsByDisciplines,
      required this.disciplines,
      required this.schoolYears,
      super.key});

  @override
  State<SchoolYears> createState() => _SchoolYearsState();
}

class _SchoolYearsState extends State<SchoolYears> {
  Color? colorFindError;
  String? textFindError;
  Service service = Service();
  List<String> schoolYears = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelPoints>(builder: (context, value, child) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              setState(
                () {
                  // remove todas as rotas da pilha e vai para disciplines
                  Routes().popRoutes(context, const HomeScreen());
                  // limpa consultas por disciplina
                  //Service.questionsByDiscipline.clear();
                  // limpa consultas por ano
                  //Service.questionsBySchoolYear.clear();
                  // limpa List disciplinas selecionadas
                  //Service.listSelectedDisciplines.clear();
                  // limpa List anos selecionados
                  //Service.listSelectedSchoolYear.clear();
                },
              );
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          title: Text(
            'Ano escolar',
            style: GoogleFonts.aboreto(color: Colors.white),
          ),
        ),
        body: Background(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0, left: 8.0, right: 8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 30,
                  child: ListSelectedScrollable(
                    list: widget.disciplines,
                    direction: Axis.horizontal,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: Divider(
                  color: Colors.white,
                ),
              ),
              Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 20,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Selecione o Ano escolar:',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width - 20,
                    maxHeight: MediaQuery.of(context).size.height / 2),
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(129, 255, 255, 255),
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        spreadRadius: 1.0,
                      )
                    ]),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemCount: widget.schoolYears.length,
                      itemBuilder: (_, int index) {
                        return AnimatedButtonCircle(
                          widget.schoolYears[index],
                          100,
                          100,
                          21,
                          () {
                            if (value.actionBtnCircle) {
                              schoolYears.add(widget.schoolYears[index]);
                              print(schoolYears);
                            } else {
                              schoolYears.remove(widget.schoolYears[index]);
                              print(schoolYears);
                            }
                          },
                        );
                      },
                    )

                    // GridListSchoolYear(modelQuestions: widget.modelQuestions),
                    ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: GestureDetector(
            onTap: () {
              if (schoolYears.isEmpty) {
                showSnackBarError(
                  context,
                  'Selecione o ano escolar para continuar.',
                  Colors.red,
                );
              } else {
                List<ModelQuestions> questionsBySchoolYear = service.getQuestionsBySchoolYear(
                    schoolYears, widget.questionsByDisciplines);
                List<Map<String, dynamic>> schoolYearAndSubject = service.getSubjectsBySchoolYears(schoolYears, widget.questionsByDisciplines);
                Routes().pushRoute(
                    context,
                    Subjects(
                      disciplines: widget.disciplines,
                      questionsBySchoolYear: questionsBySchoolYear,
                      schoolYear: schoolYears,
                      schoolYearAndSubject: schoolYearAndSubject,
                    ));
              }
            },
            child: const ButtonNext(textContent: 'Próximo')),
      );
    });
  }
}
