import 'package:estudamais/models/model_questions.dart';
import 'package:estudamais/providers/global_providers.dart';
import 'package:estudamais/service/questions_corrects_providers.dart';
import 'package:estudamais/service/questions_incorrects_providers.dart';
import 'package:estudamais/service/service_resum_questions.dart';
import 'package:estudamais/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DisiciplineExpansionPanelRadio extends StatefulWidget {
  final List<String> discipline;
  final List<ModelQuestions> resultQuestions;
  final bool activitySubjectsAndSchoolYearCorrects;
  final bool activitySubjectsAndSchoolYearIncorrects;

  const DisiciplineExpansionPanelRadio(
      {required this.discipline,
      required this.resultQuestions,
      required this.activitySubjectsAndSchoolYearCorrects,
      required this.activitySubjectsAndSchoolYearIncorrects,
      super.key});

  @override
  State<DisiciplineExpansionPanelRadio> createState() =>
      _DisiciplineExpansionPanelRadioState();
}

class _DisiciplineExpansionPanelRadioState
    extends State<DisiciplineExpansionPanelRadio> {
  List<Map<String, dynamic>> listMapSubjectsAndSchoolYear = [];
  ServiceResumQuestions questions = ServiceResumQuestions();
  @override
  Widget build(BuildContext context) {
    return Consumer3<GlobalProviders, QuestionsCorrectsProvider,
            QuestionsIncorrectsProvider>(
        builder: (context, valueGlobal, questionsCorrects, questionsIncorrects,
            child) {
      return ExpansionPanelList.radio(
        expandIconColor: Colors.white,
        expandedHeaderPadding: const EdgeInsets.symmetric(vertical: 1),
        dividerColor: Colors.indigo,
        expansionCallback: (int index, bool enable) {
          if (enable) {
            listMapSubjectsAndSchoolYear =
                questions.showSubjectsAndSchoolyearInDiscipline(
              widget.discipline[index],
              widget.resultQuestions,
            );
            if (widget.activitySubjectsAndSchoolYearIncorrects) {
              questionsIncorrects
                  .subjectsAndSchoolYear(listMapSubjectsAndSchoolYear);
              print('chamou as incorrectas');
            }
            if (widget.activitySubjectsAndSchoolYearCorrects) {
              questionsCorrects
                  .subjectsAndSchoolYear(listMapSubjectsAndSchoolYear);
              print('chamou as correctas');
            }
          }
        },
        children: widget.discipline.map<ExpansionPanelRadio>(
          (item) {
            return ExpansionPanelRadio(
              backgroundColor: const Color.fromARGB(190, 197, 202, 233),
              value: item,
              headerBuilder: (context, bool isExpanded) {
                return ListTile(
                  title:
                      Text(item, style: AppTheme.customTextStyle(fontSize: 17)),
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

                        if (widget.activitySubjectsAndSchoolYearCorrects) {
                          listSubjectsAndSchoolYearSelected =
                              questions.showSubjectAndSchoolYearSelected(
                            listMapSubjectsAndSchoolYear[index]['subjects'],
                            listMapSubjectsAndSchoolYear[index]['schoolYear'],
                          );
                          questionsCorrects.subjectAndSchoolYearSelected(
                              listSubjectsAndSchoolYearSelected);
                          valueGlobal.showSubjects(true);
                        }
                        if (widget.activitySubjectsAndSchoolYearIncorrects) {
                          listSubjectsAndSchoolYearSelected =
                              questions.showSubjectAndSchoolYearSelected(
                            listMapSubjectsAndSchoolYear[index]['subjects'],
                            listMapSubjectsAndSchoolYear[index]['schoolYear'],
                          );
                          questionsIncorrects.subjectAndSchoolYearSelected(
                              listSubjectsAndSchoolYearSelected);
                          valueGlobal.showSubjects(true);
                        }
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
                                listMapSubjectsAndSchoolYear[index]['subjects'],
                                style: AppTheme.customTextStyle()),
                            trailing: Text(
                                listMapSubjectsAndSchoolYear[index]
                                    ['schoolYear'],
                                style: AppTheme.customTextStyle(
                                    color: Colors.amber)),
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
      );
    });
  }
}
