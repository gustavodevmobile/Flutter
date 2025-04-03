import 'package:estudamais/controller/controller_disciplines.dart';
import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/screens/discipline/widget/discipline_list.dart';
import 'package:estudamais/screens/home/home.dart';
import 'package:estudamais/theme/app_theme.dart';
import 'package:estudamais/widgets/background.dart';
import 'package:estudamais/widgets/button_next.dart';
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
                        fontSize: 20, fontWeight: true),
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
            if (!mounted) return;
            controllerDisciplines.handlerFetchQuestionsByDiscipline(
                context, disciplinesSelecteds);
          },
          child: const ButtonNext(
            textContent: 'Buscar Questões',
          ),
        ),
      );
    });
  }
}
