import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:estudamais/controller/controller_questions.dart';
import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/models/model_questions.dart';
import 'package:estudamais/screens/home/home.dart';
import 'package:estudamais/screens/loading_next_page.dart';
import 'package:estudamais/screens/screen_questions/widgets/box_alternativas.dart';
import 'package:estudamais/theme/app_theme.dart';
import 'package:estudamais/widgets/feedback_modal.dart';
import 'package:estudamais/widgets/image_question.dart';
import 'package:flutter/material.dart';
import 'package:estudamais/providers/global_providers.dart';
import 'package:estudamais/screens/screen_questions/widgets/box_type_question.dart';
import 'package:provider/provider.dart';

class ScreenQuestions extends StatefulWidget {
  final Widget boxQuestions;

  final Uint8List image;
  final String alternativeA;
  final String alternativeB;
  final String alternativeC;
  final String alternativeD;
  final String response;
  final String question;
  final ModelQuestions questionAnswered;

  final PageController controller;
  final int indexQuestion;
  final String discipline;
  final String subject;
  final String id;
  final String elementarySchool;
  final String schoolYear;
  final Widget correctsAndIncorrects;
  final Widget? textButtonJump;
  final ElevatedButton? btnNextQuestion;
  final TextButton? textButtonExit;
  final String? explanation;

  const ScreenQuestions(
      {required this.boxQuestions,
      required this.image,
      required this.alternativeA,
      required this.alternativeB,
      required this.alternativeC,
      required this.alternativeD,
      required this.response,
      required this.question,
      required this.questionAnswered,
      required this.controller,
      required this.indexQuestion,
      required this.discipline,
      required this.subject,
      required this.id,
      required this.elementarySchool,
      required this.schoolYear,
      required this.correctsAndIncorrects,
      this.textButtonJump,
      this.btnNextQuestion,
      this.textButtonExit,
      this.explanation,
      super.key});

  @override
  State<ScreenQuestions> createState() => ScreenQuestionsState();
}

class ScreenQuestionsState extends State<ScreenQuestions>
    with AutomaticKeepAliveClientMixin {
  String bytesImageString = '';
  ControllerQuestions controllerQuestions = ControllerQuestions();
  final Stopwatch stopwatch = Stopwatch();
  Timer? timer;
  int elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    if (widget.image.length <= 10) {
      Uint8List string = widget.image;
      bytesImageString = utf8.decode(string);
    }
    stopwatch.start();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        elapsedSeconds = stopwatch.elapsed.inSeconds;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    stopwatch.stop();
    super.dispose();
  }

  String stopTimer() {
    timer?.cancel();
    stopwatch.stop();
    elapsedSeconds = stopwatch.elapsed.inSeconds;
    return formatTime(elapsedSeconds);
  }

  String formatTime(int seconds) {
    final h = (seconds ~/ 3600).toString().padLeft(2, '0');
    final m = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //double screenWidth = MediaQuery.of(context).size.width;
    return Consumer<GlobalProviders>(
      builder: (context, value, child) {
        return ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, top: 20.0, right: 8.0, bottom: 4.0),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white60,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(1, 3),
                            blurRadius: 1,
                            spreadRadius: 1)
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ID Questão ${widget.id}',
                              style: AppTheme.customTextStyle2(
                                fontSize: 18,
                                color: Colors.indigo,
                              ),
                            ),
                            Text(formatTime(elapsedSeconds),
                                style: AppTheme.customTextStyle2(
                                  fontSize: 18,
                                  color: Colors.black,
                                )),
                            widget.correctsAndIncorrects
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.black26,
                        thickness: 1,
                        indent: 10,
                        endIndent: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: BoxTypeQuestion(
                            widget.elementarySchool,
                            widget.discipline,
                            widget.schoolYear,
                            widget.subject,
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.black26,
                        thickness: 1,
                        indent: 10,
                        endIndent: 10,
                      ),
                      widget.boxQuestions,
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: bytesImageString == 'sem imagem'
                              ? const SizedBox.shrink()
                              : ImageQuestion(image: widget.image)),
                      BoxAlternatives(widget.alternativeA, 'A', widget.response,
                          widget.image, widget.questionAnswered,
                          onAnswered: stopTimer),
                      BoxAlternatives(widget.alternativeB, 'B', widget.response,
                          widget.image, widget.questionAnswered,
                          onAnswered: stopTimer),
                      BoxAlternatives(widget.alternativeC, 'C', widget.response,
                          widget.image, widget.questionAnswered,
                          onAnswered: stopTimer),
                      BoxAlternatives(widget.alternativeD, 'D', widget.response,
                          widget.image, widget.questionAnswered,
                          onAnswered: stopTimer),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Divider(
                          color: Colors.black26,
                          thickness: 1,
                          indent: 10,
                          endIndent: 10,
                        ),
                      ),
                      widget.explanation != null && value.isExplainable
                          ? Column(
                              children: [
                                Text(
                                  'Explicação',
                                  style: AppTheme.customTextStyle2(
                                    fontSize: 18,
                                    color: Colors.indigo,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 600),
                                    child: Text(widget.explanation ?? '',
                                        style: AppTheme.customTextStyle2(
                                          fontSize: 14,
                                          color: Colors.black,
                                        )),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                alignment: Alignment.bottomRight,
                //width: MediaQuery.of(context).size.width,
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (BuildContext context) {
                        return FeedbackModal(questionId: widget.id);
                      },
                    );
                  },
                  child: const Text(
                    'Questão com problema?',
                    style: TextStyle(color: Colors.white, fontSize: 13),

                    // AppTheme.customTextStyle(
                    //     color: Colors.white, fontSize: 10, underline: true),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Column(
                children: [
                  widget.btnNextQuestion ??
                      ElevatedButton(
                        onPressed: () {
                          controllerQuestions.nextQuestion(
                              widget.controller, context);
                        },
                        child: Text(
                          'Próxima',
                          style: AppTheme.customTextStyle2(
                              color: Colors.indigo, fontSize: 18),
                        ),
                      ),
                  widget.textButtonExit ??
                      TextButton(
                        onPressed: () {
                          Routes().pushFadeRemoveAll(
                            context,
                            const HomeScreen()
                            //const LoadingNextPage(msgFeedbasck: 'Atualizando'),
                          );
                        },
                        child: Text(
                          'Sair',
                          style: AppTheme.customTextStyle2(
                              fontSize: 16, color: Colors.amber),
                        ),
                      ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
