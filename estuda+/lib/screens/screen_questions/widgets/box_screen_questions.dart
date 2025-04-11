import 'dart:convert';
import 'dart:typed_data';
import 'package:estudamais/controller/controller_questions.dart';
import 'package:estudamais/screens/loading_next_page.dart';
import 'package:estudamais/service/service_feedbacks.dart';
import 'package:estudamais/theme/app_theme.dart';
import 'package:estudamais/widgets/feedback_modal.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';
import 'package:estudamais/providers/global_providers.dart';
import 'package:estudamais/screens/screen_questions/widgets/box_type_question.dart';
import 'package:page_transition/page_transition.dart';
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
  final TextButton? textButton;

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
      this.textButton,
      super.key});

  @override
  State<ScreenQuestions> createState() => _ScreenQuestionsState();
}

class _ScreenQuestionsState extends State<ScreenQuestions>
    with AutomaticKeepAliveClientMixin {
  String bytesImageString = '';

  @override
  void initState() {
    if (widget.image.length <= 10) {
      Uint8List string = widget.image;
      bytesImageString = utf8.decode(string);
    }
    ControllerQuestions.isAnswered = false;
    super.initState();
  }

  void nextQuestion() {
    widget.controller.nextPage(
      duration: const Duration(milliseconds: 700),
      curve: Curves.ease,
    );
    Provider.of<GlobalProviders>(listen: false, context)
        .openBoxAlreadyAnswereds(false);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<GlobalProviders>(builder: (context, value, child) {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'ID Questão ${widget.id}',
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.indigo,
                                fontWeight: FontWeight.bold),
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
                      child: BoxTypeQuestion(
                        widget.elementarySchool,
                        widget.discipline,
                        widget.schoolYear,
                        widget.subject,
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8.0),
                        child: bytesImageString == 'sem imagem'
                            ? const SizedBox.shrink()
                            : Image.memory(
                                widget.image,
                                width: MediaQuery.of(context).size.width,
                                errorBuilder: (context, error, stackTrace) {
                                  return const SizedBox.shrink();
                                },
                              )),
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
                          child: const Text(
                            'Ops, essa você já respondeu!',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 145, 18, 9)),
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
              width: MediaQuery.of(context).size.width,
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
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    nextQuestion();
                  },
                  child: Text(
                    'Pular',
                    style: AppTheme.customTextStyle2(fontSize: 20),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    nextQuestion();
                  },
                  child: Text(
                    'Próximo',
                    style: AppTheme.customTextStyle2(
                        color: Colors.indigo, fontSize: 18),
                  ),
                ),
                widget.textButton ??
                    TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            duration: const Duration(seconds: 1),
                            child: const LoadingNextPage(
                                msgFeedbasck: 'Atualizando'),
                          ),
                          (route) => false,
                        );
                      },
                      child: Text(
                        'Sair',
                        style: AppTheme.customTextStyle2(
                            fontSize: 20, color: Colors.amber),
                      ),
                    ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
