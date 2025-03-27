import 'package:flutter/material.dart';
import 'package:estudamais/controller/controller_questions.dart';
import 'package:estudamais/models/models.dart';
import 'package:provider/provider.dart';

class BoxAlternativesIncorrects extends StatefulWidget {
  final String alternative;
  final String option;
  final String response;
  final bool isAnswered;
  final int indexQuestion;
  final String idQuestion;

  const BoxAlternativesIncorrects(this.alternative, this.option, this.response,
      this.isAnswered, this.indexQuestion, this.idQuestion,
      {super.key});

  @override
  State<BoxAlternativesIncorrects> createState() =>
      _BoxAlternativesIncorrectsState();
}

class _BoxAlternativesIncorrectsState extends State<BoxAlternativesIncorrects> {
  final ControllerQuestions _controllerQuestions = ControllerQuestions();

  bool answered = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Consumer<ModelPoints>(
        builder: (context, value, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  width: MediaQuery.of(context).size.width,
                  // height: 60,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black26,
                          offset: Offset(1, 3),
                          blurRadius: 1,
                          spreadRadius: 1)
                    ],
                    color: _controllerQuestions.corAlternativa,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 2,
                      color: Colors.black38,
                    ),
                  ),
                  child: InkWell(
                    child: ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 1, color: Colors.black26),
                            color: Colors.white),
                        child: Text(
                          widget.option,
                          style: const TextStyle(fontSize: 30),
                        ),
                      ),
                      title: Text(
                        widget.alternative,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        answered = true;
                        _controllerQuestions.recoverQuestionsIncorrects(
                          widget.isAnswered,
                          widget.response,
                          widget.alternative,
                          widget.indexQuestion,
                          context,
                          widget.idQuestion,
                        );
                        value.actBoxAnswered(
                            _controllerQuestions.heightBoxIsAnswered);
                        value.answered(answered);
                      });
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
