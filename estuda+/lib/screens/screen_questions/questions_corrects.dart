import 'package:estudamais/models/model_questions.dart';
import 'package:estudamais/screens/screen_questions/widgets/box_alternatives_corrects.dart';
import 'package:estudamais/screens/screen_questions/widgets/points_Errors.dart';
import 'package:flutter/material.dart';
import 'package:estudamais/models/models.dart';

import 'package:estudamais/service/service.dart';
import 'package:estudamais/screens/screen_questions/widgets/box_questions.dart';

import 'package:estudamais/screens/screen_questions/widgets/box_screen_questions.dart';
import 'package:provider/provider.dart';

class PageQuestionsCorrects extends StatefulWidget {
  final List<ModelQuestions> resultQuestions;
  const PageQuestionsCorrects({required this.resultQuestions, super.key});

  @override
  State<PageQuestionsCorrects> createState() => _PageQuestionsCorrectsState();
}

class _PageQuestionsCorrectsState extends State<PageQuestionsCorrects> {
  Service service = Service();
  final controller = PageController();

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
                boxQuestions: BoxQuestions(
                    //mostra a pergunta
                    widget.resultQuestions[index].question),
                //mostra a imagem se tiver
                image: widget.resultQuestions[index].image,
                boxAlternativesA: BoxAlternativesCorrects(
                  // mostra a alternativa
                  widget.resultQuestions[index].alternativeA,
                  'A',
                  //pega a resposta para comparar com a resposta da alternativa
                  widget.resultQuestions[index].answer,
                  // se ja foi respondida
                ),
                boxAlternativesB: BoxAlternativesCorrects(
                  widget.resultQuestions[index].alternativeB,
                  'B',
                  widget.resultQuestions[index].answer,
                ),
                boxAlternativesC: BoxAlternativesCorrects(
                  widget.resultQuestions[index].alternativeC,
                  'C',
                  widget.resultQuestions[index].answer,
                ),
                boxAlternativesD: BoxAlternativesCorrects(
                  widget.resultQuestions[index].alternativeD,
                  'D',
                  widget.resultQuestions[index].answer,
                ),
                controller: controller,
                indexQuestion: index,
                discipline: widget.resultQuestions[index].discipline,
                subject: widget.resultQuestions[index].subject,
                id: widget.resultQuestions[index].id.toString(),
                elementarySchool:
                    widget.resultQuestions[index].elementarySchool,
                schoolYear: widget.resultQuestions[index].schoolYear,
                correctsAndIncorrects: const PointsAndErrors(),
               
              );
            },
          );
        },
      ),
    );
  }
}
