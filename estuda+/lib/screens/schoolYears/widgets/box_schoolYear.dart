// import 'package:estudamais/models/model_questions.dart';
// import 'package:estudamais/models/models.dart';
// import 'package:estudamais/service/service.dart';
// import 'package:estudamais/screens/schoolYears/widgets/animated_button_circle.dart';
// import 'package:estudamais/widgets/show_snackBar.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class BoxSchoolyear extends StatefulWidget {
//   //final String elementarySchool;
//   final String schoolYear;
//   final List<ModelQuestions> modelQuestions;
//   //final String schoolYearURL;

//   const BoxSchoolyear(
//     //this.elementarySchool,
//     this.schoolYear,
//     this.modelQuestions,
//     //this.schoolYearURL,
//     {
//     super.key,
//   });

//   @override
//   State<BoxSchoolyear> createState() => _BoxSchoolyearState();
// }

// class _BoxSchoolyearState extends State<BoxSchoolyear> {
//   //bool backButton = false;
//   Service service = Service();
//   List<String> listSchoolYear = [];

//   @override
//   void initState() {
//     Provider.of<ModelPoints>(context, listen: false).actionBtnCircle = false;
//     //Service.listSelectedSchoolYear.clear();
//     // print(
//     //     'Service.listSelectedSchoolYear do ${Service.listSelectedSchoolYear}');
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ModelPoints>(
//       builder: (context, value, child) {
//         return
//             //BoxButton(textPrimary, widthButton, heightButton, fontSizePrimary, onTap)
//             AnimatedButtonCircle(
//           widget.schoolYear,
//           //textSecondary: widget.elementarySchool,
//           100,
//          100,
//           20,
//           fontSizeSecondary: 8,
//           () {
//             if (value.actionBtnCircle) {
//               service.findSchoolYear(widget.schoolYear, widget.modelQuestions);
//               service.getQuestionsBySchoolYear(
//                   widget.schoolYear, widget.modelQuestions);
//               service.getSubjectsBySchoolYears(
//                   widget.schoolYear, widget.modelQuestions);
//               listSchoolYear.add(widget.schoolYear);
//               print('listSchoolYear $listSchoolYear');
//               // verifica se tem o ano das materias selecionadas
//               if (!service.isSchoolYear) {
//                 //Service.listSelectedSchoolYear.remove(widget.schoolYear);
//                 showSnackBar(
//                     context,
//                     'Ainda não temos questões para o ${widget.schoolYear} da(s) disciplina(s) selecionada(s)',
//                     Colors.blue);
//               }
//             } else {
//               widget.modelQuestions.removeWhere(
//                   (element) => element.schoolYear == widget.schoolYear);

//               Service.schoolYearAndSubjects
//                   .removeWhere((el) => el['schoolYear'] == widget.schoolYear);

//               // Service.listSelectedSchoolYear
//               //     .removeWhere((element) => element == widget.schoolYear);
//             }
//           },
//         );
//       },
//     );
//   }
// }
