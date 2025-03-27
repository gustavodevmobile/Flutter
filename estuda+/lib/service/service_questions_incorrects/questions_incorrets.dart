// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:estudamais/models/model_questions.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;

// class QuestionsIncorrects {
//   final String _questoesAll = dotenv.env['questoes']!;

// // PEGA TODAS AS QUESTÕES RESPONDIDAS CORRETAMENTE, COLOCA EM UMA LIST CENTRAL PARA PODER SRVIR COMO BASE DE CONSULTA. É CHAMADO NO CARREGAMENTO DA HOME.
//   Future<List<ModelQuestions>> getQuestionsIncorrects(
//       List<String> listIdIncorrects) async {
//     List<ModelQuestions> resultQuestionsIncorrect = [];
//     try {
//       http.Response response = await http.get(
//         Uri.parse('http://$_questoesAll/questao/$listIdIncorrects'),
//       );
//       if (response.statusCode == 200) {
//         var list = await json.decode(response.body);
//         for (var question in list) {
//           Uint8List bytesImage =
//               Uint8List.fromList(question['image']['data'].cast<int>());
//           question['image'] = bytesImage;
//           resultQuestionsIncorrect.add(ModelQuestions.toMap(question));
//         }
//         print('Questões incorretas recebidas com sucesso');
//       } else {
//         print('Erro ao buscar questões incorretas');
//       }
//     } catch (e) {
//       print('Erro ao buscar questões incorretas: $e');
//     }

//     //print(resultQuestionsIncorrect);
//     return resultQuestionsIncorrect;
//   }

// // pega o nome das disciplinas respondidas incorretamente
//   List<String> getDisciplineOfQuestionsIncorrects(
//       List<ModelQuestions> resultQuestionsIncorrect) {
//     List<String> list = [];
//     List<String> listDisciplinesIncorrect = [];
//     try {
//       if (resultQuestionsIncorrect.isNotEmpty) {
//         for (var disciplines in resultQuestionsIncorrect) {
//           list.add(disciplines.discipline);
//         }
//         listDisciplinesIncorrect = list.toSet().toList();
//       }
//       print('listDisciplinesIncorrect $listDisciplinesIncorrect');
//     } catch (e) {
//       print('Erro ao buscar disciplinas: $e');
//     }
//     return listDisciplinesIncorrect;
//   }

// // faz a seleção dos assuntos e anos escolares selecionados e retorna um map com o assunto e ano escolar sem repetição, como feedbackdo que foi selecionado
//   List<dynamic> showSubjectAndSchoolYearSelected(String subjects,
//       String schoolYear, List<ModelQuestions> resultQuestionsIncorrect) {
//     Map<String, dynamic> listMap = {};
//     List<dynamic> mapYearAndSubjectSelected = [];
//     List<Map<String, dynamic>> listAuxYearAndSubjectSelected = [];
//     listMap = {
//       'schoolYear': schoolYear,
//       'subjects': subjects,
//     };
//     listAuxYearAndSubjectSelected.add(listMap);
//     final listJson =
//         listAuxYearAndSubjectSelected.map((el) => jsonEncode(el)).toList();
//     final setList = listJson.toSet().toList();
//     mapYearAndSubjectSelected = setList.map((el) => jsonDecode(el)).toList();

//     print('mapYearAndSubjectSelected $mapYearAndSubjectSelected');
//     return mapYearAndSubjectSelected;
//   }

// //resultado do assunto e ano escolar selecionados
//   List<ModelQuestions> getResultQuestionsIncorrects(
//       List<ModelQuestions> resultQuestionsIncorrect,
//       List<dynamic> mapYearAndSubjectSelected) {
//     List<ModelQuestions> resultQuestions = [];
//     try {
//       for (var question in resultQuestionsIncorrect) {
//         for (var res in mapYearAndSubjectSelected) {
//           if (question.subject == res['subjects'] &&
//               question.schoolYear == res['schoolYear']) {
//             resultQuestions.add(question);
//           }
//         }
//       }
//     } catch (e) {
//       print('Erro ao buscar questões por assunto: $e');
//     }
//     print('resultQuestions $resultQuestions');
//     return resultQuestions;
//   }

//   // Manda a disciplina e todas as questões corretas
//   // faz a busca atraves da disciplina selecionada
//   // retorna uma lista de map com assunto e ano escolar, sem repetição
//   // mostra no expanted
//   List<Map<String, dynamic>> showSubjectsAndSchoolyeaIncorrects(
//       String discipline, List<ModelQuestions> listMap) {
//     Map<String, dynamic> mapYearAndSubject = {};
//     List<Map<String, dynamic>> result = [];
//     List<Map<String, dynamic>> mapListSubAndYearIncorrects = [];

//     if (listMap.isNotEmpty) {
//       for (var map in listMap) {
//         if (map.discipline == discipline) {
//           mapYearAndSubject = {
//             'schoolYear': map.schoolYear,
//             'subjects': map.subject,
//             // 'lenght':
//           };
//           result.add(mapYearAndSubject);
//         }
//       }

//       final jsonList = result.map((el) => jsonEncode(el)).toList();
//       final setList = jsonList.toSet().toList();
//       final decodeList = setList.map((el) => jsonDecode(el)).toList();

//       for (var listMap in decodeList) {
//         mapListSubAndYearIncorrects.add(listMap);
//       }

//       print('mapListSubAndYearIncorrects $mapListSubAndYearIncorrects');
//     }
//     return mapListSubAndYearIncorrects;
//   }

//   // contador das disciplinas respondidas
//   List<Map<String, dynamic>> counterDisciplineIncorrects(
//       List<ModelQuestions> resultQuestionsIncorrect) {
//     List<Map<String, dynamic>> listAmountAnswered = [];

//     List<String> portugues = [];
//     List<String> matematica = [];
//     List<String> geografia = [];
//     List<String> historia = [];
//     List<String> ciencias = [];

//     for (var dis in resultQuestionsIncorrect) {
//       switch (dis.discipline) {
//         case 'Português':
//           portugues.add(dis.discipline);
//           break;
//         case 'Matemática':
//           matematica.add(dis.discipline);
//           break;
//         case 'Geografia':
//           geografia.add(dis.discipline);
//           break;
//         case 'História':
//           historia.add(dis.discipline);
//           break;
//         case 'Ciências':
//           ciencias.add(dis.discipline);
//           break;
//       }
//     }
//     listAmountAnswered = [
//       {'discipline': 'Português', 'amount': portugues.length},
//       {'discipline': 'Matemática', 'amount': matematica.length},
//       {'discipline': 'Geografia', 'amount': geografia.length},
//       {'discipline': 'História', 'amount': historia.length},
//       {'discipline': 'Ciências', 'amount': ciencias.length}
//     ];

//     return listAmountAnswered;
//   }
// }
