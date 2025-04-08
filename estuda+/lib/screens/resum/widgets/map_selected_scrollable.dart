import 'package:estudamais/providers/global_providers.dart';
import 'package:estudamais/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MapSelectedSubjects extends StatefulWidget {
  final List listMap;
  const MapSelectedSubjects({required this.listMap, super.key});

  @override
  State<MapSelectedSubjects> createState() => _MapSelectedSubjectsState();
}

class _MapSelectedSubjectsState extends State<MapSelectedSubjects> {
  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    //bool isEmpty = false;
    return Consumer<GlobalProviders>(builder: (context, value, child) {
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
                      child: Text(' ${widget.listMap[index]['subjects']} -',
                          style: AppTheme.customTextStyle2()),
                    ),
                    Text('${widget.listMap[index]['schoolYear']}',
                        style: AppTheme.customTextStyle2(color: Colors.amber)),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: GestureDetector(
                          onTap: () {
                            setState(
                              () {
                                if (value
                                    .subjectsAndSchoolYearSelected.isNotEmpty) {
                                  value.subjectsAndSchoolYearSelected
                                      .removeWhere(
                                    (el) =>
                                        el['subjects'] ==
                                            widget.listMap[index]['subjects'] &&
                                        el['schoolYear'] ==
                                            widget.listMap[index]['schoolYear'],
                                  );
                                }
                              },
                            );
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
