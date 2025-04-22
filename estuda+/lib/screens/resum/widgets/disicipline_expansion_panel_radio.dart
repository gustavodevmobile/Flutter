import 'package:estudamais/models/model_questions.dart';
import 'package:estudamais/providers/global_providers.dart';
import 'package:estudamais/service/service_resum_questions.dart';
import 'package:estudamais/theme/app_theme.dart';
import 'package:flutter/material.dart';
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
  ValueNotifier<List<Map<String, dynamic>>> listMap =
      ValueNotifier<List<Map<String, dynamic>>>([]);
  ServiceResumQuestions questions = ServiceResumQuestions();
  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProviders>(builder: (context, valueGlobal, child) {
      return ValueListenableBuilder(
        valueListenable: listMap,
        builder: (context, value, child) {
          return ExpansionPanelList.radio(
            expandIconColor: Colors.white,
            expandedHeaderPadding: const EdgeInsets.symmetric(vertical: 1),
            dividerColor: Colors.indigo,
            expansionCallback: (int index, bool enable) {
              if (enable) {
                // Método que retorna uma lista de assuntos e anos, passando a disciplina selecionada e o resultado das questões.
                listMap.value = questions.showSubjectsAndSchoolyearInDiscipline(
                  widget.discipline[index],
                  widget.resultQuestions,
                );
                //valueGlobal.subjectsAndSchoolYearSelected.clear();
              }
            },
            children: widget.discipline.map<ExpansionPanelRadio>(
              (item) {
                return ExpansionPanelRadio(
                  backgroundColor: const Color.fromARGB(190, 197, 202, 233),
                  value: item,
                  headerBuilder: (context, bool isExpanded) {
                    return ListTile(
                      title: Text(
                        item,
                        style: AppTheme.customTextStyle(
                          fontSize: 17,
                          color: Colors.indigo,
                          fontWeight: true,
                        ),
                      ),
                    );
                  },
                  body: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: listMap.value.length,
                      itemBuilder: (context, int index) {
                        return GestureDetector(
                          onTap: () {
                            if (widget.activitySubjectsAndSchoolYearCorrects) {
                              valueGlobal
                                  .subjectAndSchoolYearSelected(value[index]);
                              valueGlobal.showSubjects(true);
                            }

                            if (widget
                                .activitySubjectsAndSchoolYearIncorrects) {
                              valueGlobal
                                  .subjectAndSchoolYearSelected(value[index]);
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
                                title: Text(value[index]['subjects'],
                                    style: AppTheme.customTextStyle(fontWeight: true)),
                                trailing: Text(value[index]['schoolYear'],
                                    style: AppTheme.customTextStyle(
                                        color: Colors.amber, fontWeight: true)),
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
        },
      );
    });
  }
}
