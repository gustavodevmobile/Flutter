import 'dart:convert';
import 'dart:typed_data';
import 'package:estudamais/models/model_questions.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ServiceResumQuestions {
  final String _questoesAll = dotenv.env['server']!;
  List<Map<String, dynamic>> mapYearAndSubjectSelected = [];

// Método responsável por buscar as questões respondidas corretamente e incorretamente, recebe uma lista de ids das questões respondidas, uma função de erro e uma função para verificar se o tempo de conexão expirou. Retorna uma lista de ModelQuestions com as questões respondidas.
  // Future<Map<String, dynamic>> getQuestionsAnswereds(List<String> listIds,
  //     Function(String) onError, Function(bool) timeExpired) async {
  //   List<ModelQuestions> resultQuestions = [];
  //   List<String> missingIds = [];
  //   try {
  //     http.Response response = await http
  //         .get(
  //       Uri.parse('$_questoesAll/questao/$listIds'),
  //     )
  //         .timeout(const Duration(seconds: 200), onTimeout: () {
  //       timeExpired(true);
  //       return http.Response('Timeout', 408);
  //     });

  //     print('Resposta: ${response.statusCode}');
  //     if (response.statusCode == 200) {
  //       var responseData = await json.decode(response.body);
  //       //print('Resposta: $responseData');
  //       if (responseData['missingIds'] != null) {
  //         missingIds = List<String>.from(responseData['missingIds'].map((id) {
  //           return id.toString();
  //         }).toList());
  //       }

  //       for (var question in responseData['questions']) {
  //         Uint8List bytesImage =
  //             Uint8List.fromList(question['image']['data'].cast<int>());
  //         question['image'] = bytesImage;
  //         resultQuestions.add(ModelQuestions.toModelQuestions(question));
  //       }
  //     } else if (response.statusCode == 408) {
  //       onError('Tempo de espera excedido.\nTente novamente mais tarde.');
  //     } else {
  //       onError('Erro ao buscar questões respondidas: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     onError('Erro ao buscar resumo de questões: getQuestionsAnswereds $e');
  //     print(e);
  //   }
  //   return {
  //     'questions': resultQuestions,
  //     'missingIds': missingIds,
  //   };
  // }

//Método responsável por buscar as disciplinas das questões respondidas, retorna uma lista de disciplinas sem repetição.
  List<String> getDisciplineOfQuestions(List<ModelQuestions> resultQuestions) {
    List<String> listDisciplines = [];
    try {
      if (resultQuestions.isNotEmpty) {
        for (var disciplines in resultQuestions) {
          listDisciplines.add(disciplines.discipline);
        }
      }
      print('Disciplinas: $listDisciplines');
    } catch (e) {
      print('Erro ao buscar disciplinas: $e');
    }
    return listDisciplines.toSet().toList();
  }

  // faz a consulta das questões corretas pelo mapYearAndSubjectSelected
  List<ModelQuestions> getResultQuestions(List<ModelQuestions> resultQuestions,
      List<dynamic> mapYearAndSubjectSelected, Function(String) onError) {
    List<ModelQuestions> result = [];

    try {
      for (var question in resultQuestions) {
        for (var res in mapYearAndSubjectSelected) {
          if (question.subject == res['subjects'] &&
              question.schoolYear == res['schoolYear']) {
            result.add(question);
          }
        }
      }
    } catch (e) {
      onError('Erro ao buscar questões por assunto: $e');
    }

    return result;
  }

  // Manda a disciplina e todas as questões corretas
  // faz a busca atraves da disciplina selecionada
  // retorna uma lista de map com assunto e ano escolar, sem repetição
  // mostra no expanted
  List<Map<String, dynamic>> showSubjectsAndSchoolyearInDiscipline(
      String discipline,
      List<ModelQuestions> resultQuestions,
      Function(String) onError) {
    List<Map<String, dynamic>> mapListSubAndYear = [];
    Map<String, dynamic> mapYearAndSubject = {};
    List<Map<String, dynamic>> result = [];

    try {
      if (resultQuestions.isNotEmpty) {
        for (var map in resultQuestions) {
          if (map.discipline == discipline) {
            mapYearAndSubject = {
              'schoolYear': map.schoolYear,
              'subjects': map.subject,
              // 'lenght':
            };
            result.add(mapYearAndSubject);
          }
        }

        final jsonList = result.map((el) => jsonEncode(el)).toList();
        final setList = jsonList.toSet().toList();
        final decodeList = setList.map((el) => jsonDecode(el)).toList();

        for (var listMap in decodeList) {
          mapListSubAndYear.add(listMap);
        }
      }
    } catch (e) {
      onError('Erro ao buscar assuntos e ano escolar: $e');
    }
    return mapListSubAndYear;
  }

// contador das disciplinas respondidas
  List<Map<String, dynamic>> counterDiscipline(
      List<ModelQuestions> resultQuestions) {
    List<Map<String, dynamic>> listAmountAnswered = [];

    List<String> portugues = [];
    List<String> matematica = [];
    List<String> geografia = [];
    List<String> historia = [];
    List<String> ciencias = [];

    try {
      for (var dis in resultQuestions) {
        switch (dis.discipline) {
          case 'Português':
            portugues.add(dis.discipline);
            break;
          case 'Matemática':
            matematica.add(dis.discipline);
            break;
          case 'Geografia':
            geografia.add(dis.discipline);
            break;
          case 'História':
            historia.add(dis.discipline);
            break;
          case 'Ciências':
            ciencias.add(dis.discipline);
            break;
        }
      }
      listAmountAnswered = [
        {'discipline': 'Português', 'amount': portugues.length},
        {'discipline': 'Matemática', 'amount': matematica.length},
        {'discipline': 'Geografia', 'amount': geografia.length},
        {'discipline': 'História', 'amount': historia.length},
        {'discipline': 'Ciências', 'amount': ciencias.length}
      ];
    } catch (e) {
      print('Erro ao contar disciplinas respondidas: $e');
    }
    return listAmountAnswered;
  }
}
