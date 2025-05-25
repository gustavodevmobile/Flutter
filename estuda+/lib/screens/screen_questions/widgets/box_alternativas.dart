import 'dart:typed_data';

import 'package:estudamais/models/model_questions.dart';
import 'package:estudamais/storage_sqllite/storage_sqflite.dart';
import 'package:estudamais/theme/app_theme.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';
import 'package:estudamais/controller/controller_questions.dart';
import 'package:estudamais/providers/global_providers.dart';
import 'package:provider/provider.dart';

class BoxAlternatives extends StatefulWidget {
  final String alternative;
  final String option;
  final String response;
  final String idQuestion;
  final Uint8List? image;
  final ModelQuestions questionAnswered;
  final Function() onAnswered;
  final bool isRecovery;
  final String timeAnswered;

  const BoxAlternatives(
      this.alternative,
      this.option,
      this.response,
      this.idQuestion,
      this.image,
      this.questionAnswered,
      this.isRecovery,
      this.timeAnswered,
      {super.key,
      required this.onAnswered});

  @override
  State<BoxAlternatives> createState() => _BoxAlternativesState();
}

class _BoxAlternativesState extends State<BoxAlternatives> {
  final ControllerQuestions controllerQuestions = ControllerQuestions();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
                            border: Border.all(
                              width: 1,
                              color: Colors.black26,
                            ),
                            color: Colors.white),
                        child: Text(
                          widget.option,
                          style: AppTheme.customTextStyle2(
                              color: Colors.black87,
                              fontSize: screenWidth * 0.05),
                        ),
                      ),
                      title: Text(
                        widget.alternative,
                        style: AppTheme.customTextStyle2(
                            color: Colors.black87, fontSize: 18),
                      ),
                    ),
                    onTap: () async {
                      if (widget.isRecovery) {
                        controllerQuestions.answered(widget.idQuestion,
                            (isAnswered) {
                          if (!isAnswered) {
                            setState(() {
                              controllerQuestions.recoverQuestionsIncorrects(
                                  widget.response.trim(),
                                  widget.alternative.trim(),
                                  context,
                                  widget.idQuestion,
                                  widget.questionAnswered,
                                  widget.timeAnswered);
                            });
                          } else {
                            if (context.mounted) {
                              showSnackBarFeedback(
                                  context,
                                  'Ops, essa você já respondeu!',
                                  Colors.orange);
                            }
                          }
                        }, (onError) {
                          showSnackBarFeedback(context, onError, Colors.red);
                        });
                      } else {
                        await StorageSqflite()
                            .existsQuestionById(widget.idQuestion)
                            .then((isExists) {
                          if (!isExists) {
                            setState(
                              () {
                                controllerQuestions.isCorrect(
                                    widget.response.trim(),
                                    widget.alternative.trim(),
                                    context,
                                    widget.questionAnswered,
                                    widget.timeAnswered);
                              },
                            );
                          } else {
                            if (context.mounted) {
                              showSnackBarFeedback(
                                  context,
                                  'Ops, essa você já respondeu!',
                                  Colors.orange);
                            }
                          }
                        });
                      }
                      widget.onAnswered();
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
