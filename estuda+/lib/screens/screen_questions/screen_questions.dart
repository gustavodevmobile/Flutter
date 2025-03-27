import 'package:estudamais/models/model_questions.dart';
import 'package:estudamais/screens/loading_next_page.dart';
import 'package:estudamais/screens/screen_questions/widgets/points_Errors.dart';
import 'package:flutter/material.dart';
import 'package:estudamais/models/models.dart';

import 'package:estudamais/service/service.dart';
import 'package:estudamais/screens/screen_questions/widgets/box_alternativas.dart';
import 'package:estudamais/screens/screen_questions/widgets/box_questions.dart';

import 'package:estudamais/screens/screen_questions/widgets/box_screen_questions.dart';
import 'package:page_transition/page_transition.dart';
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
  //Timer? timer;

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
      body: Consumer<ModelPoints>(
        builder: (context, value, child) {
          return PageView.builder(
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
                  value.isAnswered,
                  index,
                  widget.questions[index].id.toString(),
                ),
                boxAlternativesB: BoxAlternatives(
                  widget.questions[index].alternativeB,
                  'B',
                  widget.questions[index].answer,
                  value.isAnswered,
                  index,
                  widget.questions[index].id.toString(),
                ),
                boxAlternativesC: BoxAlternatives(
                  widget.questions[index].alternativeC,
                  'C',
                  widget.questions[index].answer,
                  value.isAnswered,
                  index,
                  widget.questions[index].id.toString(),
                ),
                boxAlternativesD: BoxAlternatives(
                  widget.questions[index].alternativeD,
                  'D',
                  widget.questions[index].answer,
                  value.isAnswered,
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
                textButton: TextButton(
                  onPressed: () {
                    //Routes().pushRouteFade(context, const TransitionPage());
                    Navigator.pushAndRemoveUntil(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        duration: const Duration(seconds: 1),
                        child: const LoadingNextPage(),
                      ),
                      (route) => false,
                    );

                    // // atualiza os pontos das corretas na homoScreen
                    // Provider.of<ModelPoints>(context, listen: false)
                    //     .uptadeCorrects(DaoUserResum.listIdCorrects.length);
                    // // atualiza os pontos das incorretas na homoScreen
                    // Provider.of<ModelPoints>(context, listen: false)
                    //     .updateIncorrects(DaoUserResum.listIdIncorrects.length);
                    // Service.resultQuestionsBySubjectsAndSchoolYear.clear();
                  },
                  child: const Text(
                    'Sair',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                answered: value.isAnswered,
              );
            },
          );
        },
      ),
    );
  }
}
