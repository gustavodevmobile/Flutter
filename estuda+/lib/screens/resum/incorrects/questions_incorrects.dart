import 'package:estudamais/shared_preference/storage_shared_preferences.dart';
import 'package:estudamais/models/model_questions.dart';
import 'package:estudamais/screens/resum/incorrects/widgets/box_alternatives_incorrects.dart';
import 'package:estudamais/screens/screen_questions/widgets/points_Errors.dart';
import 'package:estudamais/widgets/background.dart';

import 'package:flutter/material.dart';
import 'package:estudamais/providers/global_providers.dart';

import 'package:estudamais/screens/screen_questions/widgets/box_questions.dart';

import 'package:estudamais/screens/screen_questions/widgets/box_screen_questions.dart';
import 'package:provider/provider.dart';

class PageQuestionsIncorrects extends StatefulWidget {
  final List<ModelQuestions> resultQuestions;
  const PageQuestionsIncorrects({required this.resultQuestions, super.key});

  @override
  State<PageQuestionsIncorrects> createState() =>
      _PageQuestionsIncorrectsState();
}

class _PageQuestionsIncorrectsState extends State<PageQuestionsIncorrects> {
  //Service service = Service();
  final controller = PageController();
  StorageSharedPreferences sharedPreferences = StorageSharedPreferences();

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
              itemCount: widget.resultQuestions.length,
              itemBuilder: (context, index) {
                return ScreenQuestions(
                  boxQuestions:
                      BoxQuestions(widget.resultQuestions[index].question),
                  image: widget.resultQuestions[index].image,
                  alternativeA: widget.resultQuestions[index].alternativeA,
                  alternativeB: widget.resultQuestions[index].alternativeB,
                  alternativeC: widget.resultQuestions[index].alternativeC,
                  alternativeD: widget.resultQuestions[index].alternativeD,
                  response: widget.resultQuestions[index].answer,
                  question: widget.resultQuestions[index].question,
                  questionAnswered: widget.resultQuestions[index],
                  controller: controller,
                  indexQuestion: index,
                  discipline: widget.resultQuestions[index].discipline,
                  subject: widget.resultQuestions[index].subject,
                  id: widget.resultQuestions[index].id.toString(),
                  elementarySchool:
                      widget.resultQuestions[index].elementarySchool,
                  schoolYear: widget.resultQuestions[index].schoolYear,
                  correctsAndIncorrects: const PointsAndErrors(),
                  explanation: widget.resultQuestions[index].explanation,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
