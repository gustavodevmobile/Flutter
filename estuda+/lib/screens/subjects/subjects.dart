import 'package:estudamais/controller/controller_subjects.dart';
import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/screens/home/home.dart';
import 'package:estudamais/screens/screen_questions/screen_questions.dart';
import 'package:estudamais/widgets/animated_button_retangulare.dart';
import 'package:estudamais/widgets/background.dart';
import 'package:estudamais/widgets/button_next.dart';
import 'package:estudamais/widgets/list_selected_scrollable.dart';
import 'package:estudamais/widgets/show_loading_dialog.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';
import 'package:estudamais/providers/global_providers.dart';
import 'package:estudamais/service/service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Subjects extends StatefulWidget {
  final List<String> disciplines;
  final List<String> schoolYear;
  final List<Map<String, dynamic>> schoolYearAndSubject;

  const Subjects(
      {required this.disciplines,
      required this.schoolYear,
      required this.schoolYearAndSubject,
      super.key});
  @override
  State<Subjects> createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {
  final Service service = Service();
  final ScrollController scrollControllerSubjects = ScrollController();
  List<Map<String, dynamic>> listMapSubjectsAndSchoolYear = [];
  Map<String, dynamic> mapSubjectsAndSchoolYear = {};
  ControllerSubjects controllerSubjects = ControllerSubjects();

  @override
  void dispose() {
    scrollControllerSubjects.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Consumer<GlobalProviders>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
                onPressed: () {
                  Routes().popRoutes(context, const HomeScreen());
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                )),
            title: Text(
              'Disciplina / Ano escolar / Assunto',
              style: GoogleFonts.aboreto(
                  fontSize: screenWidth * 0.03, color: Colors.white),
            ),
          ),
          body: Background(
            child: ListView(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 5.0, left: 8.0, right: 8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 35,
                    child: ListSelectedScrollable(
                      list: widget.disciplines,
                      direction: Axis.horizontal,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 30,
                    child: ListSelectedScrollable(
                        list: widget.schoolYear, direction: Axis.horizontal),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Selecione os assuntos:',
                      style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width,
                        minHeight: 0,
                        maxHeight: 400),
                    decoration: BoxDecoration(
                        color: Colors.white38,
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 15, bottom: 15, right: 1),
                      child: Scrollbar(
                        controller: scrollControllerSubjects,
                        thumbVisibility: true,
                        child: ListView.builder(
                          shrinkWrap: true,
                          controller: scrollControllerSubjects,
                          itemCount: widget.schoolYearAndSubject.length,
                          itemBuilder: (context, int index) {
                            return AnimatedButtonRectangular(
                              title: widget.schoolYearAndSubject[index]
                                  ['subject'],
                              onTap: () {
                                if (value.actionBtnRetangulare) {
                                  mapSubjectsAndSchoolYear = {
                                    'disciplines':
                                        widget.schoolYearAndSubject[index]
                                            ['discipline'],
                                    'schoolYear':
                                        widget.schoolYearAndSubject[index]
                                            ['schoolYear'],
                                    'subjects': widget
                                        .schoolYearAndSubject[index]['subject'],
                                  };
                                  listMapSubjectsAndSchoolYear
                                      .add(mapSubjectsAndSchoolYear);
                                } else {
                                  listMapSubjectsAndSchoolYear.removeWhere(
                                    (el) =>
                                        el['schoolYear'] ==
                                            widget.schoolYearAndSubject[index]
                                                ['schoolYear'] &&
                                        el['subjects'] ==
                                            widget.schoolYearAndSubject[index]
                                                ['subject'] &&
                                        el['disciplines'] ==
                                            widget.schoolYearAndSubject[index]
                                                ['discipline'],
                                  );
                                }
                                print(
                                    'listMapSubjectsAndSchoolYear $listMapSubjectsAndSchoolYear');
                              },
                              leading: widget.schoolYearAndSubject[index]
                                  ['discipline'],
                              tralling: widget.schoolYearAndSubject[index]
                                  ['schoolYear'],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniCenterFloat,
          floatingActionButton: GestureDetector(
            onTap: () {
              if (listMapSubjectsAndSchoolYear.isEmpty) {
                showSnackBarFeedback(context,
                    'Selecione o(s) assunto(s) desejado(s).', Colors.blue);
              } else {
                showLoadingDialog(context, 'Buscando questões...');
                // Chama o método handlerFetchQuestions do controller
                controllerSubjects.handlerFetchQuestions(
                  listMapSubjectsAndSchoolYear,
                  (questionsResult) {
                    if (questionsResult.isNotEmpty) {
                      // Fecha o loading dialog
                      closeLoadingOpen(context);
                      Routes().pushRoute(
                          context,
                          PageQuestionsBySchoolYear(
                              questions: questionsResult));
                    }
                  },
                  (error) {
                    // Fecha o loading dialog
                    closeLoadingOpen(context);
                    showSnackBarFeedback(context, error, Colors.red);
                  },
                );
              }
            },
            child: const ButtonNext(
              textContent: 'Responder',
            ),
          ),
        );
      },
    );
  }
}
