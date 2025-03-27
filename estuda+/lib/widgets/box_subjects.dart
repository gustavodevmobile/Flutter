// import 'package:estudamais/models/models.dart';

// import 'package:estudamais/service/questions_corrects.dart';
// import 'package:estudamais/service/questions_incorrets.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class BoxSubjectsAndSchoolYear extends StatefulWidget {
//   final String subject;
//   final String schoolYear;

//   const BoxSubjectsAndSchoolYear(
//       {required this.subject, required this.schoolYear, super.key});

//   @override
//   State<BoxSubjectsAndSchoolYear> createState() =>
//       _BoxSubjectsAndSchoolYearState();
// }

// class _BoxSubjectsAndSchoolYearState extends State<BoxSubjectsAndSchoolYear> {
//   bool enable = false;
//   Color backgroundButton = const Color.fromARGB(255, 101, 114, 185);
//   Color textButton = Colors.white;
//   double widthBorder = 2;
//   Color colorBorder = Colors.white;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 30),
//       child: Consumer<ModelPoints>(
//         builder: (context, value, child) {
//           return AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             curve: Curves.easeIn,
//             decoration: BoxDecoration(
//               color: backgroundButton,
//               border: Border.all(
//                 width: widthBorder,
//                 color: colorBorder,
//               ),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: ListTile(
//               contentPadding: const EdgeInsets.symmetric(horizontal: 10),
//               minLeadingWidth: 2,
//               minTileHeight: 5,
//               onTap: () {
//                 setState(
//                   () {
//                     enable = !enable;
//                     if (enable) {
//                       textButton = Colors.indigo;
//                       backgroundButton = Colors.white;
//                       widthBorder = 3;
//                       colorBorder = Colors.green;
//                       QuestionsCorrects()
//                           .getQuestionsCorrectsForSubjects(widget.subject);
//                       QuestionsIncorrects()
//                           .getQuestionsIncorrectsForSubjects(widget.subject);

//                       value.showSubjects(true);
//                       print(
//                           'QuestionsIncorrects.resultQuestions ${QuestionsIncorrects.resultQuestions}');
//                       print(
//                           'QuestionsIncorrects.subjectsOfQuestionsCorrects ${QuestionsIncorrects.subjectsOfQuestionsIncorrects}');
//                     } else {
//                       value.showSubjects(true);
//                       textButton = Colors.white;
//                       backgroundButton =
//                           const Color.fromARGB(255, 101, 114, 185);
//                       widthBorder = 2;
//                       colorBorder = Colors.white;
//                       QuestionsCorrects.subjectsOfQuestionsCorrects
//                           .remove(widget.subject);
//                       QuestionsCorrects.resultQuestions
//                           .removeWhere((el) => el.subject == widget.subject);
//                           QuestionsIncorrects.subjectsOfQuestionsIncorrects
//                           .remove(widget.subject);
//                       QuestionsIncorrects.resultQuestions
//                           .removeWhere((el) => el.subject == widget.subject);
//                       print(
//                           'QuestionsIncorrects.resultQuestions ${QuestionsIncorrects.resultQuestions}');
//                       print(
//                           'QuestionsIncorrects.subjectsOfQuestionsIncorrects ${QuestionsIncorrects.subjectsOfQuestionsIncorrects}');
//                     }
//                   },
//                 );
//               },
//               leading: Visibility(
//                 visible: enable,
//                 child: const Icon(
//                   Icons.check,
//                   color: Colors.green,
//                   size: 25,
//                 ),
//               ),
//               title: Text(
//                 widget.subject,
//                 style: TextStyle(
//                   color: textButton,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 17,
//                 ),
//               ),
//               trailing: Text(
//                 widget.schoolYear,
//                 style: TextStyle(
//                   color: textButton,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 13,
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
