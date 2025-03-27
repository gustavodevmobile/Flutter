import 'package:estudamais/models/models.dart';
import 'package:estudamais/service/questions_incorrects_providers.dart';
import 'package:estudamais/service/service_questions_incorrects/questions_incorrets.dart';
import 'package:estudamais/service/service_resum_questions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ExpandedIncorrects extends StatefulWidget {
  final List<String> discipline;

  const ExpandedIncorrects({required this.discipline, super.key});

  @override
  State<ExpandedIncorrects> createState() => _ExpandedIncorrectsState();
}

class _ExpandedIncorrectsState extends State<ExpandedIncorrects> {
  bool enable = false;
  ServiceResumQuestions questionsIncorrects = ServiceResumQuestions();
  List<Map<String, dynamic>> mapListSubAndYearIncorrects = [];
  @override
  Widget build(BuildContext context) {
    return Consumer2<ModelPoints, QuestionsIncorrectsProvider>(
        builder: (context, value, incorrects, child) {
      return ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Selecione a disciplina e o assunto:',
              style: GoogleFonts.aboreto(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          ExpansionPanelList.radio(
            expandIconColor: Colors.white,
            //materialGapSize: 10,
            expandedHeaderPadding: const EdgeInsets.symmetric(vertical: 1),
            dividerColor: Colors.indigo,
            expansionCallback: (int index, bool enable) {
              //print('enable $enable e index $index');
              if (enable) {
                setState(
                  () {
                    // FAZ A CONSULTA PARA OBTER O ASSUNTO E O ANO ESCOLAR TANTO DAS CORRETAS COMO DAS INCORRETAS
                    mapListSubAndYearIncorrects =
                        questionsIncorrects.showSubjectsAndSchoolyear(
                      widget.discipline[index],
                      incorrects.resultQuestionsIncorrects,
                    );
                  },
                );
              }
            },
            children: widget.discipline.map<ExpansionPanelRadio>(
              (item) {
                return ExpansionPanelRadio(
                  backgroundColor: const Color.fromARGB(190, 197, 202, 233),
                  value: item,
                  headerBuilder: (context, bool isExpanded) {
                    return ListTile(
                      title: Text(item,
                          style: GoogleFonts.aboreto(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    );
                  },
                  body: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: mapListSubAndYearIncorrects.length,
                      itemBuilder: (context, int index) {
                        return GestureDetector(
                          onTap: () {
                            List<dynamic> listSubjectsAndSchoolYearSelected =
                                [];
                            listSubjectsAndSchoolYearSelected =
                                questionsIncorrects
                                    .showSubjectAndSchoolYearSelected(
                              mapListSubAndYearIncorrects[index]['subjects'],
                              mapListSubAndYearIncorrects[index]['schoolYear'],
                              //incorrects.resultQuestionsIncorrects,
                            );
                            incorrects.subjectAndSchoolYearSelected(
                                listSubjectsAndSchoolYearSelected);
                            value.showSubjects(true);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(255, 101, 114, 185),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black54,
                                    blurRadius: 1,
                                    offset: Offset(0, 1),
                                  )
                                ],
                              ),
                              child: ListTile(
                                minTileHeight: 10,
                                title: Text(
                                  mapListSubAndYearIncorrects[index]
                                      ['subjects'],
                                  style: GoogleFonts.aboreto(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: Text(
                                  mapListSubAndYearIncorrects[index]
                                      ['schoolYear'],
                                  style: GoogleFonts.aboreto(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ],
      );
    });
  }
}
