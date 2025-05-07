import 'package:estudamais/controller/controller_schoolyear.dart';
import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/screens/home/home.dart';
import 'package:estudamais/screens/schoolYears/widgets/animated_button_circle.dart';
import 'package:estudamais/screens/subjects/subjects.dart';
import 'package:estudamais/widgets/background.dart';
import 'package:estudamais/widgets/button_next.dart';
import 'package:estudamais/widgets/list_selected_scrollable.dart';
import 'package:estudamais/widgets/show_loading_dialog.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:estudamais/providers/global_providers.dart';
import 'package:provider/provider.dart';
//import 'package:progress_button/progress_button.dart';

class SchoolYears extends StatefulWidget {
  final List<String> disciplines;
  final List<String> schoolYears;
  const SchoolYears(
      {required this.disciplines, required this.schoolYears, super.key});

  @override
  State<SchoolYears> createState() => _SchoolYearsState();
}

class _SchoolYearsState extends State<SchoolYears> {
  List<String> selectedSchoolYears = [];
  final ControllerSchoolyear controllerSchoolyear = ControllerSchoolyear();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Consumer<GlobalProviders>(builder: (context, value, child) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              setState(
                () {
                  Routes().popRoutes(context, const HomeScreen());
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Selecione o Ano escolar:',
                    style: TextStyle(
                        fontSize: screenWidth * 0.05,
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
                              selectedSchoolYears
                                  .add(widget.schoolYears[index]);
                              //print(schoolYears);
                            } else {
                              selectedSchoolYears
                                  .remove(widget.schoolYears[index]);
                              //print(schoolYears);
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
              if (selectedSchoolYears.isEmpty) {
                showSnackBarFeedback(
                  context,
                  'Selecione o ano escolar para continuar.',
                  Colors.blue,
                );
              } else {
                selectedSchoolYears.sort();
                // Chama Dialog de loading
                showLoadingDialog(context, 'Buscando questões...');
                controllerSchoolyear.handlerFetchSubjects(
                  widget.disciplines,
                  selectedSchoolYears,
                  (response) {
                    if (response.isNotEmpty) {
                      // Fecha o loading dialog se tiver aerto
                      closeLoadingOpen(context);
                      Routes().pushRoute(
                        context,
                        Subjects(
                          disciplines: widget.disciplines,
                          schoolYear: selectedSchoolYears,
                          schoolYearAndSubject: response,
                        ),
                      );
                    } else {
                      showSnackBarFeedback(
                        context,
                        'Nenhum assunto encontrado',
                        Colors.red,
                      );

                      //closeLoadingOpen(context);
                    }
                  },
                  (error) {
                    showSnackBarFeedback(context, error, Colors.red);
                    closeLoadingOpen(context); // Fecha o loading dialog
                  },
                );
              }
            },
            child: const ButtonNext(textContent: 'Próximo')),
      );
    });
  }
}
