// 1 - NO DRAWER da home, É SELECIONADO A DISCIPLINA DESEJADA, O MÉTODO getQuestionsByDiscipline BUSCA TODAS AS QUESTÕES DA DISCIPLINA SELECIONADA E ARMAZENADA NA LIST questionsByDiscipline;

// 2 - NA SCREEN schoolYear.dart, SELECIONA-SE OS ANOS DA DISCIPLINA E O MÉTODO getSubjectsOfDisciplineAndSchoolYear BUSCA TODOS OS 'ASSUNTOS' DA DISCIPLINA E DO ANO SELECIONADOS;

// 3 - NA SCREEN subject.dart, SELECIONA-SE OS ASSUNTOS DESEJADOS E O MÉTODO getQuestionsAllBySubjectsAndSchoolYear BUSCA TODAS AS QUESTÕES DO ANO E DO ASSUNTO SELECIONADOS EM questionsByDiscipline;

import 'dart:convert';
import 'package:estudamais/shared_preference/storage_shared_preferences.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:dio/dio.dart';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:estudamais/models/model_questions.dart';
import 'package:flutter/foundation.dart';

class Service {
  final String _questoesAll = dotenv.env['server']!;
  StorageSharedPreferences sharedPreferences = StorageSharedPreferences();

// busca os nomes das disciplinas das questões
  Future<List<String>> getDisciplines() async {
    List<String> listDisciplines = [];
    http.Response response = await http.get(
      Uri.parse('$_questoesAll/disciplinas'),
    );
    try {
      if (response.statusCode == 200) {
        var list = await json.decode(response.body);
        print('Todas as disciplinas recebidas com sucesso');
        for (var dis in list) {
          listDisciplines.add(dis);
        }
      }
      print('listDisciplines $listDisciplines');
    } catch (err) {
      print('Erro ao buscar disciplinas: $err');
    }
    return listDisciplines..sort();
  }

  // busca as questões por disciplinas
  Future<List<ModelQuestions>> getQuestionsByDiscipline(
      // recebe uma lista das disciplinas selecionadas
      List<String> disciplines,
      BuildContext context ) async {
    List<ModelQuestions> questionsByDiscipline = [];
    // converte essa lista em json para ser enviado como parametro para rota
    var listDisciplinesJson = jsonEncode(disciplines);
    http.Response response = await http.get(
      Uri.parse('$_questoesAll/questoes/$listDisciplinesJson'),
    );
    try {
      if (response.statusCode == 200) {
        var list = await json.decode(response.body);
        print('Todas as questões recebidas com sucesso');

        // faz a busca dos ids das questões já respodidas.
        List<String> listIdsAnswereds = await sharedPreferences.recoverIds(
            StorageSharedPreferences.keyIdsAnswereds,
            (error) => showSnackBarFeedback(context, error, Colors.red));

        // converte a imagem de bytes para um Uint8List
        for (var question in list) {
          Uint8List bytesImage =
              Uint8List.fromList(question['image']['data'].cast<int>());
          question['image'] = bytesImage;
          questionsByDiscipline.add(ModelQuestions.toMap(question));
        }

       
        // retira as questões que ja foram respodidas pelos ids das questões respondidas.
        for (var id in listIdsAnswereds) {
          questionsByDiscipline.removeWhere((el) => el.id == id);
        }

        for (var qs in questionsByDiscipline) {
          print('questões: ${qs.id}, ${qs.schoolYear}, ${qs.discipline}');
        }
      }
    } catch (err) {
      print('Erro ao buscar questões por disciplina: $err');
    }

    return questionsByDiscipline;
  }

  // BUSCA AS QUESTÕES POR ANO DAS QUESTÕES SELECIONADAS POR DISCIPLINA
  List<ModelQuestions> getQuestionsBySchoolYear(
      List<String> schoolYear, List<ModelQuestions> questionsByDiscipline) {
    List<ModelQuestions> questionsBySchoolYear = [];
    //listSelectedSchoolYear.add(schoolYear);
    //listSelectedSchoolYear.toSet().toList();
    try {
      if (questionsByDiscipline.isNotEmpty) {
        for (var questions in questionsByDiscipline) {
          for (var years in schoolYear) {
            if (questions.schoolYear == years) {
              questionsBySchoolYear.add(questions);
            }
          }
        }
      }
      // print('listSelectedSchoolYear $listSelectedSchoolYear');
      for (var q in questionsBySchoolYear) {
        print(
            'questões: ${q.id}, ${q.schoolYear} ${q.discipline}, ${q.subject}');
      }
    } catch (error) {
      print('Erro ao buscar questões por ano: $error');
    }
    return questionsBySchoolYear;
  }

// BUSCA A DISCIPLINA, O ANO E O ASSUNTO DAS QUESTÕES OBTIDAS POR ANO SELECIONADO
  List<Map<String, dynamic>> getSubjectsBySchoolYears(
      List<String> years, List<ModelQuestions> questionsByDisciplines) {
    List<Map<String, dynamic>> schoolYearAndSubjects = [];
    Map<String, dynamic> mapYearAndSubject = {};
    List<Map<String, dynamic>> result = [];

    try {
      for (var map in questionsByDisciplines) {
        for (var year in years) {
          if (year == map.schoolYear) {
            mapYearAndSubject = {
              'disciplines': map.discipline,
              'schoolYear': map.schoolYear,
              'subjects': map.subject
            };
            result.add(mapYearAndSubject);
          }
        }
      }
      final jsonList = result.map((el) => jsonEncode(el)).toList();
      final uniqueList = jsonList.toSet().toList();
      var newMap = uniqueList.map((item) => jsonDecode(item)).toList();

      for (var listMap in newMap) {
        schoolYearAndSubjects.add(listMap);
      }
      print('schoolYearAndSubjects $schoolYearAndSubjects');
    } catch (err) {
      print('Falha na busca dos dados: $err');
    }
    return schoolYearAndSubjects;
  }

  // BUSCA AS QUESTÕES POR DISCIPLINA, ANO E ASSUNTO QUE FORAM SELECIONADAS
  // NAS TELAS ANTERIORES
  List<ModelQuestions> getQuestionsAllBySubjectsAndSchoolYear(
      List<Map<String, dynamic>> listMapSubjectsAndSchoolYear,
      List<ModelQuestions> questionsBySchoolYear) {
    List<ModelQuestions> resultQuestionsBySubjectsAndSchoolYear = [];

    try {
      if (questionsBySchoolYear.isNotEmpty) {
        // BUSCA AS QUESTÕES DA DISCIPLINA SELECIONANA
        for (var question in questionsBySchoolYear) {
          for (var elements in listMapSubjectsAndSchoolYear) {
            if (question.schoolYear == elements['schoolYear'] &&
                question.subject == elements['subjects'] &&
                question.discipline == elements['disciplines']) {
              resultQuestionsBySubjectsAndSchoolYear.add(question);
            }
          }
        }
        // var result = questionsBySchoolYear
        //     .where((element) =>
        //         element.schoolYear == mapSubjectsAndSchoolYear['schoolYear'] &&
        //         element.subject == subject &&
        //         element.discipline == discipline)
        //     .toList();
        // for (var questions in result) {
        //   //print('questions $questions');
        //   resultQuestionsBySubjectsAndSchoolYear.add(questions);
        //   //resultQuestionsBySubjectsAndSchoolYear.shuffle();
        // }
        print(
            'resultQuestionsBySubjectsAndSchoolYear $resultQuestionsBySubjectsAndSchoolYear');
      }
    } catch (err) {
      print('Erro ao buscar questões: $err');
    }
    return resultQuestionsBySubjectsAndSchoolYear;
  }

// verifica se tem o ano selecionada na lista das questões das disciplinas selecionadas
  // void findSchoolYear(
  //     String schoolYear, List<ModelQuestions> questionsByDiscipline) {
  //   List<ModelQuestions> contain = [];
  //   for (var year in questionsByDiscipline) {
  //     if (year.schoolYear.contains(schoolYear)) {
  //       contain.add(year);
  //     }
  //   }
  //   if (contain.isEmpty) {
  //     isSchoolYear = false;
  //   } else {
  //     isSchoolYear = true;
  //   }
  //   print('isSchoolYear $isSchoolYear');
  // }
}
