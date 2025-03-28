import 'package:estudamais/models/model_questions.dart';
import 'package:estudamais/models/models.dart';
import 'package:estudamais/service/questions_corrects_providers.dart';
import 'package:estudamais/service/service_resum_questions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ExpandedCorrects extends StatefulWidget {
  final List<String> discipline;
  final List<ModelQuestions> resultQuestions;

  const ExpandedCorrects(
      {required this.discipline, required this.resultQuestions, super.key});

  @override
  State<ExpandedCorrects> createState() => _ExpandedCorrectsState();
}

class _ExpandedCorrectsState extends State<ExpandedCorrects> {
  bool enable = false;
  ServiceResumQuestions questionsCorrects = ServiceResumQuestions();
  List<Map<String, dynamic>> listMapSubjectsAndSchoolYear = [];
  @override
  Widget build(BuildContext context) {
    return Consumer2<ModelPoints, QuestionsCorrectsProvider>(
        builder: (context, value, corrects, child) {
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
            //materialGapSize: 1,
            expandedHeaderPadding: const EdgeInsets.symmetric(vertical: 1),
            dividerColor: Colors.indigo,
            //expandedHeaderPadding: const EdgeInsets.all(1),
            expansionCallback: (int index, bool enable) {
              //print('enable $enable e index $index');
              if (enable) {
                setState(
                  () {
                    listMapSubjectsAndSchoolYear =
                        questionsCorrects.showSubjectsAndSchoolyear(
                      widget.discipline[index],
                      widget.resultQuestions,
                    );
                    corrects
                        .subjectsAndSchoolYear(listMapSubjectsAndSchoolYear);
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
                      itemCount: listMapSubjectsAndSchoolYear.length,
                      itemBuilder: (context, int index) {
                        return GestureDetector(
                          onTap: () {
                            List<dynamic> listSubjectsAndSchoolYearSelected = [];
                            // faz a list dos assuntos selecionados e mostra na accumulated_corrects
                            listSubjectsAndSchoolYearSelected =
                                questionsCorrects.showSubjectAndSchoolYearSelected(
                              listMapSubjectsAndSchoolYear[index]['subjects'],
                              listMapSubjectsAndSchoolYear[index]['schoolYear'],
                            );
                            corrects.subjectAndSchoolYearSelected(
                                listSubjectsAndSchoolYearSelected);
                            value.showSubjects(true);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
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
                                  listMapSubjectsAndSchoolYear[index]
                                      ['subjects'],
                                  style: GoogleFonts.aboreto(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: Text(
                                  listMapSubjectsAndSchoolYear[index]
                                      ['schoolYear'],
                                  style: GoogleFonts.aboreto(
                                      color: Colors.yellow,
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
