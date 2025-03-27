import 'package:estudamais/models/models.dart';
import 'package:estudamais/service/questions_corrects_providers.dart';
import 'package:estudamais/service/questions_incorrects_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MapSelectedDisciplines extends StatefulWidget {
  final List listMap;
  const MapSelectedDisciplines({required this.listMap, super.key});

  @override
  State<MapSelectedDisciplines> createState() => _MapSelectedDisciplinesState();
}

class _MapSelectedDisciplinesState extends State<MapSelectedDisciplines> {
  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    return Consumer3<ModelPoints, QuestionsCorrectsProvider,
            QuestionsIncorrectsProvider>(
        builder: (context, value, corrects, incorrects, child) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Scrollbar(
          thumbVisibility: true,
          controller: scrollController,
          child: ListView.builder(
              controller: scrollController,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: widget.listMap.length,
              itemBuilder: (context, int index) {
                return Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Text(
                        ' ${widget.listMap[index]['subjects']} -',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16),
                      ),
                    ),
                    Text(
                      '${widget.listMap[index]['schoolYear']}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow,
                          fontSize: 14),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (corrects
                                  .subjectsAndSchoolYearSelected.isNotEmpty) {
                                corrects.subjectsAndSchoolYearSelected
                                    .removeWhere(
                                  (el) =>
                                      el['subjects'] ==
                                          widget.listMap[index]['subjects'] &&
                                      el['schoolYear'] ==
                                          widget.listMap[index]['schoolYear'],
                                );
                              }

                              if (incorrects
                                  .subjectsAndSchoolYearSelected.isNotEmpty) {
                                incorrects.subjectsAndSchoolYearSelected
                                    .removeWhere(
                                  (el) =>
                                      el['subjects'] ==
                                          widget.listMap[index]['subjects'] &&
                                      el['schoolYear'] ==
                                          widget.listMap[index]['schoolYear'],
                                );
                              }
                            });
                          },
                          child: const Icon(
                            Icons.clear_sharp,
                            color: Colors.red,
                            size: 20,
                          )),
                    )
                  ],
                );
              }),
        ),
      );
    });
  }
}
