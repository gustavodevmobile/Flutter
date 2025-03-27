// import 'package:estudamais/models/model_questions.dart';
// import 'package:estudamais/screens/schoolYears/widgets/box_schoolYear.dart';
// import 'package:flutter/material.dart';
// import 'package:estudamais/models/models.dart';
// import 'package:provider/provider.dart';

// class GridListSchoolYear extends StatefulWidget {
//   final List<ModelQuestions> modelQuestions;
//   const GridListSchoolYear({required this.modelQuestions, super.key});

//   @override
//   State<GridListSchoolYear> createState() => _GridListState();
// }

// class _GridListState extends State<GridListSchoolYear> {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ModelPoints>(builder: (context, value, child) {
//       return GridView.count(
//         crossAxisCount: 3,
//         mainAxisSpacing: 6.0,
//         crossAxisSpacing: 6.0,
//         children: <Widget>[
//           BoxSchoolyear(
            
//             '1º Ano',
//             widget.modelQuestions,
//           ),
//           BoxSchoolyear(
//             'Fundamental 1',
//             '2º Ano',
//             widget.modelQuestions,
//           ),
//           BoxSchoolyear(
//             'Fundamental 1',
//             '3º Ano',
//             widget.modelQuestions,
//           ),
//           BoxSchoolyear(
//             'Fundamental 1',
//             '4º Ano',
//             widget.modelQuestions,
//           ),
//           BoxSchoolyear(
//             'Fundamental 1',
//             '5º Ano',
//             widget.modelQuestions,
//           ),
//           BoxSchoolyear(
//             'Fundamental 2',
//             '6º Ano',
//             widget.modelQuestions,
//           ),
//           BoxSchoolyear(
//             'Fundamental 2',
//             '7º Ano',
//             widget.modelQuestions,
//           ),
//           BoxSchoolyear(
//             'Fundamental 2',
//             '8º Ano',
//             widget.modelQuestions,
//           ),
//           BoxSchoolyear(
//             'Fundamental 2',
//             '9º Ano',
//             widget.modelQuestions,
//           ),
//         ],
//       );
//     });
//   }
// }

// // import 'package:estudamais/service/service.dart';
// // import 'package:estudamais/widgets/box_button_animated.dart';
// // import 'package:estudamais/widgets/box_schoolYear.dart';
// // import 'package:flutter/material.dart';
// // import 'package:estudamais/models/models.dart';
// // import 'package:provider/provider.dart';

// // class GridList extends StatefulWidget {
// //   GridList({super.key});

// //   @override
// //   State<GridList> createState() => _GridListState();
// // }

// // class _GridListState extends State<GridList> {
// //   bool backButton = false;
// //   double shadowBox = 10;
// //   Color colorShadow = Colors.black87;
// //   @override
// //   Widget build(BuildContext context) {
// //     return Consumer<ModelPoints>(builder: (context, value, child) {
// //       return GridView.builder(
// //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //             crossAxisCount: 3,
// //             crossAxisSpacing: 4.0,
// //             mainAxisSpacing: 4.0,
// //           ),
// //           itemCount: Service.schoolYears.length,
// //           itemBuilder: (context, int index) {
// //             return BoxButton(Service.schoolYears[index], 100, 100, 20, () {
// //               if (value.actionBtn) {
// //                 Service().findQuestionsByDispliceAndSchoolYear('matematica', '4ano');
// //               } else {
// //                 // Service.schoolYearAndSubjects.removeWhere(
// //                 //     (el) => el['year'] == Service.schoolYears[index]);
// //                 print(Service.schoolYearAndSubjects);
// //               }
// //             });
// //             //);
// //           });
// //     });
// //   }
// // }
