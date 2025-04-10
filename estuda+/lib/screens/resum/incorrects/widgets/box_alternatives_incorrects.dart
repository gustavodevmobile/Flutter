import 'package:estudamais/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:estudamais/controller/controller_questions.dart';
import 'package:estudamais/providers/global_providers.dart';
import 'package:provider/provider.dart';

class BoxAlternativesIncorrects extends StatefulWidget {
  final String alternative;
  final String option;
  final String response;
  final int indexQuestion;
  final String idQuestion;

  const BoxAlternativesIncorrects(this.alternative, this.option, this.response,
      this.indexQuestion, this.idQuestion,
      {super.key});

  @override
  State<BoxAlternativesIncorrects> createState() =>
      _BoxAlternativesIncorrectsState();
}

class _BoxAlternativesIncorrectsState extends State<BoxAlternativesIncorrects> {
  final ControllerQuestions controllerQuestions = ControllerQuestions();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Consumer<GlobalProviders>(
        builder: (context, value, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black26,
                          offset: Offset(1, 3),
                          blurRadius: 1,
                          spreadRadius: 1)
                    ],
                    color: controllerQuestions.corAlternativa,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 2,
                      color: Colors.black38,
                    ),
                  ),
                  child: InkWell(
                    child: ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 1, color: Colors.black26),
                            color: Colors.white),
                        child: Text(
                          widget.option,
                          style: AppTheme.customTextStyle2(
                              color: Colors.black87, fontSize: 25),
                        ),
                      ),
                      title: Text(
                        widget.alternative,
                        style: AppTheme.customTextStyle2(
                            color: Colors.black87, fontSize: 18),
                      ),
                    ),
                    onTap: () async {
                      if (!ControllerQuestions.isAnswered) {
                        setState(
                          () {
                            controllerQuestions.recoverQuestionsIncorrects(
                              widget.response,
                              widget.alternative,
                              context,
                              widget.idQuestion,
                            );
                          },
                        );
                      } else {
                        value.openBoxAlreadyAnswereds(true);
                      }
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
