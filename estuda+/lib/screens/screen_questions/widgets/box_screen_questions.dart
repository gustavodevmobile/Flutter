import 'dart:convert';
import 'dart:typed_data';
import 'package:estudamais/controller/controller_questions.dart';
import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/screens/loading_next_page.dart';
import 'package:estudamais/theme/app_theme.dart';
import 'package:estudamais/widgets/feedback_modal.dart';
import 'package:estudamais/widgets/image_question.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';
import 'package:estudamais/providers/global_providers.dart';
import 'package:estudamais/screens/screen_questions/widgets/box_type_question.dart';
import 'package:provider/provider.dart';

class ScreenQuestions extends StatefulWidget {
  final Widget boxQuestions;
  final Uint8List image;
  final Widget boxAlternativesA;
  final Widget boxAlternativesB;
  final Widget boxAlternativesC;
  final Widget boxAlternativesD;
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

  const ScreenQuestions(
      {required this.boxQuestions,
      required this.image,
      required this.boxAlternativesA,
      required this.boxAlternativesB,
      required this.boxAlternativesC,
      required this.boxAlternativesD,
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
      super.key});

  @override
  State<ScreenQuestions> createState() => _ScreenQuestionsState();
}

class _ScreenQuestionsState extends State<ScreenQuestions>
    with AutomaticKeepAliveClientMixin {
  String bytesImageString = '';
  ControllerQuestions controllerQuestions = ControllerQuestions();

  @override
  void initState() {
    if (widget.image.length <= 10) {
      Uint8List string = widget.image;
      bytesImageString = utf8.decode(string);
    }
    ControllerQuestions.isAnswered = false;
    super.initState();
  }

  // void nextQuestion() {
  //   widget.controller.nextPage(
  //     duration: const Duration(milliseconds: 700),
  //     curve: Curves.ease,
  //   );
  //   Provider.of<GlobalProviders>(listen: false, context)
  //       .openBoxAlreadyAnswereds(false);
  // }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double screenWidth = MediaQuery.of(context).size.width;
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
                      widget.boxAlternativesA,
                      widget.boxAlternativesB,
                      widget.boxAlternativesC,
                      widget.boxAlternativesD,
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Divider(
                          color: Colors.black26,
                          thickness: 1,
                          indent: 10,
                          endIndent: 10,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Center(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: value.isAnsweredBox ? 30 : 0,
                            child: Text(
                              'Ops, essa você já respondeu!',
                              style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 145, 18, 9)),
                            ),
                          ),
                        ),
                      ),
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
                          Routes().pushFade(
                            context,
                            const LoadingNextPage(msgFeedbasck: 'Atualizando'),
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
