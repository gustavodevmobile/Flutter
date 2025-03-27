import 'dart:typed_data';
import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/screens/home/home.dart';
import 'package:estudamais/service/service.dart';
import 'package:flutter/material.dart';

import 'package:estudamais/models/models.dart';
import 'package:estudamais/screens/screen_questions/widgets/box_type_question.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';

class ScreenQuestions extends StatefulWidget {
  final Widget boxQuestions;
  final Uint8List image;
  final Widget? boxAlternativesA;
  final Widget? boxAlternativesB;
  final Widget? boxAlternativesC;
  final Widget? boxAlternativesD;
  final PageController controller;
  final int indexQuestion;
  final String discipline;
  final String subject;
  final String id;
  final String elementarySchool;
  final String schoolYear;
  final Widget? correctsAndIncorrects;
  final String? title;
  final TextButton? textButton;
  final bool answered;

  const ScreenQuestions(
      {required this.boxQuestions,
      required this.image,
      this.boxAlternativesA,
      this.boxAlternativesB,
      this.boxAlternativesC,
      this.boxAlternativesD,
      required this.controller,
      required this.indexQuestion,
      required this.discipline,
      required this.subject,
      required this.id,
      required this.elementarySchool,
      required this.schoolYear,
      this.correctsAndIncorrects,
      this.title,
      this.textButton,
      this.answered = false,
      super.key});

  @override
  State<ScreenQuestions> createState() => _ScreenQuestionsState();
}

class _ScreenQuestionsState extends State<ScreenQuestions>
    with AutomaticKeepAliveClientMixin {
  Color corAlternativa = Colors.white;
  double heightAnswered = 0;
  //DaoUserResum databeseUserResum = DaoUserResum();
  // DaoRight databaseRight = DaoRight();
  // DaoWrong databaseWrongs = DaoWrong();
  double heightImage = 0;
  Service service = Service();
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ModelPoints>(builder: (context, value, child) {
      return Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('./assets/images/ball-7280265_640.jpg'),
                fit: BoxFit.cover),
          ),
          child: ListView(
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  alignment: Alignment.center,
                  child: Text(
                    widget.title ?? '',
                    style: GoogleFonts.aboreto(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  )),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
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
                              widget.correctsAndIncorrects ??
                                  const SizedBox.shrink(),
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
                          child: Image.memory(widget.image,
                              width: MediaQuery.of(context).size.width,
                              errorBuilder: (context, error, stackTrace) {
                            //print('Without image or image is with error');
                            return const SizedBox.shrink();
                          }),
                        ),
                        widget.boxAlternativesA ?? const SizedBox.shrink(),
                        widget.boxAlternativesB ?? const SizedBox.shrink(),
                        widget.boxAlternativesC ?? const SizedBox.shrink(),
                        widget.boxAlternativesD ?? const SizedBox.shrink(),
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
                            child: SizedBox(
                              height: value.boxIsAnswered,
                              child: const Text(
                                'Ops, essa você já respondeu!',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 145, 18, 9)),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        //print('teste');
                        widget.controller.nextPage(
                            duration: const Duration(seconds: 1),
                            curve: Curves.ease);
                        value.answered(false);
                        value.actBoxAnswered(0);
                      },
                      child: const Text('Próximo'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                widget.controller.animateToPage(
                                    widget.indexQuestion - 1,
                                    duration: const Duration(milliseconds: 600),
                                    curve: Curves.ease);
                              },
                              child: const Text(
                                'Voltar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            widget.textButton ??
                                TextButton(
                                  onPressed: () {
                                    Routes()
                                        .popRoutes(context, const HomeScreen());
                                    //QuestionsCorrects.resultQuestions.clear();
                                  },
                                  child: const Text(
                                    'Sair',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
