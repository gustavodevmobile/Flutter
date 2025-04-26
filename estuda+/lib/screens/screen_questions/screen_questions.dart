import 'package:estudamais/models/model_questions.dart';
import 'package:estudamais/screens/screen_questions/widgets/points_Errors.dart';
import 'package:estudamais/widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:estudamais/providers/global_providers.dart';

import 'package:estudamais/service/service.dart';
import 'package:estudamais/screens/screen_questions/widgets/box_alternativas.dart';
import 'package:estudamais/screens/screen_questions/widgets/box_questions.dart';

import 'package:estudamais/screens/screen_questions/widgets/box_screen_questions.dart';
import 'package:provider/provider.dart';

class PageQuestionsBySchoolYear extends StatefulWidget {
  final List<ModelQuestions> questions;
  const PageQuestionsBySchoolYear({required this.questions, super.key});

  @override
  State<PageQuestionsBySchoolYear> createState() =>
      _PageQuestionsBySchoolYearState();
}

class _PageQuestionsBySchoolYearState extends State<PageQuestionsBySchoolYear> {
  Service service = Service();
  final controller = PageController();
  ValueNotifier<String> discipline = ValueNotifier<String>('');

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 5,
        automaticallyImplyLeading: false,
        
      ),
      body: Consumer<GlobalProviders>(
        builder: (context, value, child) {
          return Background(
            child: PageView.builder(
              controller: controller,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.questions.length,
              itemBuilder: (context, index) {
                return ScreenQuestions(
                  boxQuestions: BoxQuestions(widget.questions[index].question),
                  image: widget.questions[index].image,
                  boxAlternativesA: BoxAlternatives(
                    widget.questions[index].alternativeA,
                    'A',
                    widget.questions[index].answer,
                    index,
                    widget.questions[index].id.toString(),
                  ),
                  boxAlternativesB: BoxAlternatives(
                    widget.questions[index].alternativeB,
                    'B',
                    widget.questions[index].answer,
                    index,
                    widget.questions[index].id.toString(),
                  ),
                  boxAlternativesC: BoxAlternatives(
                    widget.questions[index].alternativeC,
                    'C',
                    widget.questions[index].answer,
                    index,
                    widget.questions[index].id.toString(),
                  ),
                  boxAlternativesD: BoxAlternatives(
                    widget.questions[index].alternativeD,
                    'D',
                    widget.questions[index].answer,
                    index,
                    widget.questions[index].id.toString(),
                  ),
                  controller: controller,
                  indexQuestion: index,
                  discipline: widget.questions[index].discipline,
                  subject: widget.questions[index].subject,
                  id: widget.questions[index].id.toString(),
                  elementarySchool: widget.questions[index].elementarySchool,
                  schoolYear: widget.questions[index].schoolYear,
                  correctsAndIncorrects: const PointsAndErrors(),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
