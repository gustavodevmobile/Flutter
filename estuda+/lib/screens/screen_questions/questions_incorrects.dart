import 'package:estudamais/database/storage_shared_preferences.dart';
import 'package:estudamais/models/model_questions.dart';
import 'package:estudamais/screens/loading_next_page.dart';
import 'package:estudamais/screens/screen_questions/widgets/box_alternatives_incorrects.dart';

import 'package:flutter/material.dart';
import 'package:estudamais/models/models.dart';

import 'package:estudamais/screens/screen_questions/widgets/box_questions.dart';

import 'package:estudamais/screens/screen_questions/widgets/box_screen_questions.dart';
import 'package:page_transition/page_transition.dart';
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
      body: Consumer<ModelPoints>(
        builder: (context, value, child) {
          return PageView.builder(
            controller: controller,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.resultQuestions.length,
            itemBuilder: (context, index) {
              return ScreenQuestions(
                boxQuestions:
                    BoxQuestions(widget.resultQuestions[index].question),
                image: widget.resultQuestions[index].image,
                boxAlternativesA: BoxAlternativesIncorrects(
                  widget.resultQuestions[index].alternativeA,
                  'A',
                  widget.resultQuestions[index].answer,
                  value.isAnswered,
                  index,
                  widget.resultQuestions[index].id.toString(),
                ),
                boxAlternativesB: BoxAlternativesIncorrects(
                  widget.resultQuestions[index].alternativeB,
                  'B',
                  widget.resultQuestions[index].answer,
                  value.isAnswered,
                  index,
                  widget.resultQuestions[index].id.toString(),
                ),
                boxAlternativesC: BoxAlternativesIncorrects(
                  widget.resultQuestions[index].alternativeC,
                  'C',
                  widget.resultQuestions[index].answer,
                  value.isAnswered,
                  index,
                  widget.resultQuestions[index].id.toString(),
                ),
                boxAlternativesD: BoxAlternativesIncorrects(
                  widget.resultQuestions[index].alternativeD,
                  'D',
                  widget.resultQuestions[index].answer,
                  value.isAnswered,
                  index,
                  widget.resultQuestions[index].id.toString(),
                ),
                controller: controller,
                indexQuestion: index,
                discipline: widget.resultQuestions[index].discipline,
                subject: widget.resultQuestions[index].subject,
                id: widget.resultQuestions[index].id.toString(),
                elementarySchool:
                    widget.resultQuestions[index].elementarySchool,
                schoolYear: widget.resultQuestions[index].schoolYear,
                textButton: TextButton(
                  onPressed: () {
                    //Routes().pushRouteFade(context, const TransitionPage());
                    Navigator.pushAndRemoveUntil(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade,
                          duration: const Duration(seconds: 1),
                          child: const LoadingNextPage(msgFeedbasck: 'Atualizando')),
                      (route) => false,
                    );

                    // atualiza os pontos das corretas na homoScreen
                    // Provider.of<ModelPoints>(context, listen: false)
                    //     .uptadeCorrects(DaoUserResum.listIdCorrects.length);
                    // // atualiza os pontos das incorretas na homoScreen
                    // Provider.of<ModelPoints>(context, listen: false)
                    //     .updateIncorrects(DaoUserResum.listIdIncorrects.length);
                  },
                  child: const Text(
                    'Sair',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
