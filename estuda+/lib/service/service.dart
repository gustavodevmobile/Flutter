// 1 - NO DRAWER da home, É SELECIONADO A DISCIPLINA DESEJADA, O MÉTODO getQuestionsByDiscipline BUSCA TODAS AS QUESTÕES DA DISCIPLINA SELECIONADA E ARMAZENADA NA LIST questionsByDiscipline;

// 2 - NA SCREEN schoolYear.dart, SELECIONA-SE OS ANOS DA DISCIPLINA E O MÉTODO getSubjectsOfDisciplineAndSchoolYear BUSCA TODOS OS 'ASSUNTOS' DA DISCIPLINA E DO ANO SELECIONADOS;

// 3 - NA SCREEN subject.dart, SELECIONA-SE OS ASSUNTOS DESEJADOS E O MÉTODO getQuestionsAllBySubjectsAndSchoolYear BUSCA TODAS AS QUESTÕES DO ANO E DO ASSUNTO SELECIONADOS EM questionsByDiscipline;

import 'dart:convert';
import 'package:estudamais/shared_preference/storage_shared_preferences.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:estudamais/models/model_questions.dart';
import 'package:flutter/foundation.dart';

// Classe Service responsável por fazer as requisições HTTP para o servidor
// e manipular os dados recebidos. Ela contém métodos para buscar disciplinas, questões por disciplina, questões por ano escolar e assuntos relacionados às questões.
/// A classe também possui métodos para filtrar questões com base em critérios específicos, como disciplina, ano escolar e assunto. Além disso, ela utiliza o pacote http para fazer as requisições e o pacote dotenv para gerenciar variáveis de ambiente.

// Nesta classe faz 2 chamadas externas para o servidor, sendo elas:
//// 1 - getDisciplines: busca as disciplinas disponíveis no servidor.
//// 2 - getQuestionsByDiscipline: busca as questões das disciplinas selecionadas.

class Service {
  final String _questoesAll = dotenv.env['server']!;
  StorageSharedPreferences sharedPreferences = StorageSharedPreferences();

// Busca os nomes das disciplinas das questões
  Future<List<String>> getDisciplines(Function(String) onError) async {
    List<String> listDisciplines = [];
    http.Response response = await http
        .get(
      Uri.parse('$_questoesAll/disciplinas'),
    )
        .timeout(const Duration(seconds: 20), onTimeout: () {
      // Retorna uma resposta de timeout com status 408
      return http.Response("Timeout", 408);
    });
    try {
      if (response.statusCode == 200) {
        var list = await json.decode(response.body);
        for (var dis in list) {
          listDisciplines.add(dis);
        }
      } else if (response.statusCode == 408) {
        onError('Tempo de espera excedido.\nTente novamente mais tarde.');
      } else {
        onError('Erro ao buscar disciplinas: ${response.statusCode}');
      }
    } catch (err) {
      onError('Erro ao buscar disciplinas: $err');
    }
    print('Disciplinas recebidas com sucesso: $listDisciplines');
    return listDisciplines..sort();
  }

  // static List<ModelQuestions> processQuestions(List<dynamic> data) {
  //   List<ModelQuestions> processedQuestions = [];
  //   for (var question in data) {
  //     Uint8List bytesImage =
  //         Uint8List.fromList(question['image']['data'].cast<int>());
  //     question['image'] = bytesImage;
  //     processedQuestions.add(ModelQuestions.toMap(question));
  //   }
  //   return processedQuestions;
  // }

  Future<List<String>> fetchSchoolYearByDisciplines(
      List<String> disciplines, Function(String) onError) async {
    List<String> schoolYear = [];
    // final body = jsonEncode({
    //   'disciplines': disciplines.map((d) => Uri.encodeComponent(d)).toList(),
    // });
    try {
      http.Response response = await http
          .post(
        Uri.parse('$_questoesAll/disciplines/schoolyear'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'disciplines': disciplines,
        }),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        // Retorna uma resposta de timeout com status 408
        return http.Response("Timeout", 408);
      });

      if (response.statusCode == 200) {
        var list = await json.decode(response.body);

        for (var year in list) {
          schoolYear.add(year);
        }
      } else if (response.statusCode == 408) {
        onError('Tempo de espera excedido.\nTente novamente mais tarde.');
      } else {
        onError('Erro ao buscar disciplinas: ${response.statusCode}');
      }
    } catch (e) {
      onError('Erro ao buscar disciplinas: $e');
    }
    return schoolYear..sort();
  }

  Future<List<Map<String, dynamic>>> fetchSubjectsByDisciplineAndSchoolYear(
      List<String> disciplines,
      List<String> schoolYear,
      Function(String) onError) async {
    List<Map<String, dynamic>> listSubjects = [];

    final body = jsonEncode({
      'disciplines': disciplines,
      'schoolYear': schoolYear,
    });
    try {
      http.Response response = await http
          .post(Uri.parse('$_questoesAll/disciplines/schoolyears/subjects'),
              headers: {
                'Content-Type': 'application/json',
              },
              body: body
              // jsonEncode({
              //   'disciplines': disciplines,
              //   'schoolYear': schoolYear,
              // }),
              )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        // Retorna uma resposta de timeout com status 408
        return http.Response("Timeout", 408);
      });
      print('Requisição: $body');
      print('Resposta: ${response.body}');
      if (response.statusCode == 200) {
        var list = await json.decode(response.body);
        for (var el in list) {
          listSubjects.add(el);
        }
      } else if (response.statusCode == 408) {
        onError('Tempo de espera excedido.\nTente novamente mais tarde.');
      } else {
        onError(
            'Erro ao buscar assuntos por disciplina e ano escolar: ${response.statusCode}');
      }
    } catch (e) {
      onError('Erro ao buscar assuntos por disciplina e ano escolar: $e');
    }
    for (var el in listSubjects) {
      print('${el['discipline']}, ${el['schoolYear']}, ${el['subject']}');
    }
   
    return listSubjects;
  }

  // Busca as questões por disciplinas
  // Future<List<ModelQuestions>> getQuestionsByDiscipline(
  //     // recebe uma lista das disciplinas selecionadas
  //     List<String> disciplines,
  //     BuildContext context,
  //     Function(String) onError,
  //     Function(bool) isTimeout) async {
  //   //List<ModelQuestions> resultIlates = [];
  //   List<ModelQuestions> questionsByDiscipline = [];
  //   // converte essa lista em json para ser enviado como parametro para rota
  //   var listDisciplinesJson = jsonEncode(disciplines);
  //   http.Response response = await http
  //       .get(
  //     Uri.parse('$_questoesAll/questoes/$listDisciplinesJson'),
  //   )
  //       .timeout(const Duration(seconds: 100), onTimeout: () {
  //     isTimeout(true);
  //     return http.Response("Timeout", 408);
  //   });
  //   try {
  //     if (response.statusCode == 200) {
  //       var list = await json.decode(response.body);
  //       //print('Todas as questões recebidas com sucesso');

  //       // processa as questões recebidas do servidor em um isolate
  //       // questionsByDiscipline =
  //       //     await compute<List<dynamic>, List<ModelQuestions>>(
  //       //         Service.processQuestions, list);
  //       // faz a busca dos ids das questões já respodidas.
  //       List<String> listIdsAnswereds = await sharedPreferences.recoverIds(
  //           StorageSharedPreferences.keyIdsAnswereds,
  //           (error) => showSnackBarFeedback(context, error, Colors.red));

  //       //converte a imagem de bytes para um Uint8List
  //       for (var question in list) {
  //         Uint8List bytesImage =
  //             Uint8List.fromList(question['image']['data'].cast<int>());
  //         question['image'] = bytesImage;
  //         questionsByDiscipline.add(ModelQuestions.toMap(question));
  //       }

  //       // retira as questões que ja foram respodidas pelos ids das questões respondidas.
  //       for (var id in listIdsAnswereds) {
  //         questionsByDiscipline.removeWhere((el) => el.id == id);
  //       }
  //     } else if (response.statusCode == 408) {
  //       onError(
  //           'Tempo limite de resposta excedido.\nTente novamente mais tarde.');
  //     } else {
  //       onError('Erro ao buscar questões: ${response.statusCode}');
  //     }
  //   } catch (err) {
  //     print('Erro ao buscar questões por disciplina: $err');
  //   }

  //   return questionsByDiscipline;
  // }

  // Filtra as questões por ano escolar das disciplinas selecionadas.
  List<ModelQuestions> getQuestionsBySchoolYear(List<String> schoolYear,
      List<ModelQuestions> questionsByDiscipline, Function(String) onError) {
    List<ModelQuestions> questionsBySchoolYear = [];

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
    } catch (error) {
      onError('Erro ao buscar questões por ano: $error');
    }
    return questionsBySchoolYear;
  }

// Filtra o nome da disciplina, ano escolar e assunto das questões selecionadas.
  List<Map<String, dynamic>> getSubjectsBySchoolYears(List<String> years,
      List<ModelQuestions> questionsByDisciplines, Function(String) onError) {
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
      //print('schoolYearAndSubjects $schoolYearAndSubjects');
    } catch (err) {
      onError('Falha na busca dos dados: $err');
    }
    return schoolYearAndSubjects;
  }

  // filtra as questões com base no método getSubjectsBySchoolYears
  List<ModelQuestions> getQuestionsAllBySubjectsAndSchoolYear(
      List<Map<String, dynamic>> listMapSubjectsAndSchoolYear,
      List<ModelQuestions> questionsBySchoolYear,
      Function(String) onError) {
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
      }
    } catch (err) {
      onError('Erro ao buscar questões: $err');
    }
    return resultQuestionsBySubjectsAndSchoolYear;
  }
}
