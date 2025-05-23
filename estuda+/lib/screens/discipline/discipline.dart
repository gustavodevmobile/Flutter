import 'package:estudamais/controller/controller_disciplines.dart';
import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/screens/discipline/widget/discipline_list.dart';
import 'package:estudamais/screens/home/home.dart';
import 'package:estudamais/screens/schoolYears/school_years.dart';
import 'package:estudamais/theme/app_theme.dart';
import 'package:estudamais/widgets/background.dart';
import 'package:estudamais/widgets/button_next.dart';
import 'package:estudamais/widgets/show_loading_dialog.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';
import 'package:estudamais/providers/global_providers.dart';
import 'package:provider/provider.dart';

class Discipline extends StatefulWidget {
  final List<String> disciplines;
  const Discipline({required this.disciplines, super.key});

  @override
  State<Discipline> createState() => _DisciplineState();
}

class _DisciplineState extends State<Discipline> {
  ControllerDisciplines controllerDisciplines = ControllerDisciplines();
  List<String> disciplinesSelecteds = [];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
                child: Center(
                  child: Text(
                    'Selecione a(s) disciplina(s):',
                    style: AppTheme.customTextStyle(
                        fontSize: screenWidth * 0.04, fontWeight: true),
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
                        disciplinesSelecteds.add(
                          discipline,
                        );
                      } else {
                        disciplinesSelecteds.remove(
                          discipline,
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: GestureDetector(
          onTap: () async {
            if (disciplinesSelecteds.isEmpty) {
              showSnackBarFeedback(context,
                  'Selecione uma disciplina para continuar.', Colors.blue);
            } else {
              showLoadingDialog(context, 'Buscando questões...');
              controllerDisciplines.handlerFetchSchoolYear(
                  context, disciplinesSelecteds, (schoolYearResult) {
                if (schoolYearResult.isEmpty) {
                  showSnackBarFeedback(
                      context,
                      'Todas as questões desta disciplina já foram respondidas',
                      Colors.blue);
                } else {
                  schoolYearResult.sort();
                  // Chama Dialog de loading
                  closeLoadingOpen(context);
                  Routes().pushRoute(
                    context,
                    SchoolYears(
                      disciplines: disciplinesSelecteds,
                      schoolYears: schoolYearResult,
                    ),
                  );
                }
              }, (error) {
                closeLoadingOpen(context);
                showSnackBarFeedback(context, error, Colors.red);
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
