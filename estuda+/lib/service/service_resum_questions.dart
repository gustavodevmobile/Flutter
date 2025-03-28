import 'dart:convert';
import 'dart:typed_data';
import 'package:estudamais/models/model_questions.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ServiceResumQuestions {
  final String _questoesAll = dotenv.env['questoes']!;
  List<Map<String, dynamic>> mapYearAndSubjectSelected = [];
// PEGA TODAS AS QUESTÕES RESPONDIDAS CORRETAMENTE pelo id da questão, COLOCA EM UMA LIST CENTRAL PARA PODER SERVIR COMO BASE DE CONSULTA. É CHAMADO NO CARREGAMENTO DA HOME.

  Future<List<ModelQuestions>> getQuestions(
    List<String> listIds,
  ) async {
    List<ModelQuestions> resultQuestionsCorrect = [];
    try {
      http.Response response = await http.get(
        Uri.parse('http://$_questoesAll/questao/$listIds'),
      );
      if (response.statusCode == 200) {
        var list = await json.decode(response.body);
        for (var question in list) {
          Uint8List bytesImage =
              Uint8List.fromList(question['image']['data'].cast<int>());
          question['image'] = bytesImage;
          resultQuestionsCorrect.add(ModelQuestions.toMap(question));
        }

        print('Questões corretas recebidas com sucesso');
      } else {
        print('resultQuestionsCorrect $resultQuestionsCorrect');
      }
    } catch (e) {
      print('Erro ao buscar resumo de questões: $e');
    }
    return resultQuestionsCorrect;
  }

// PEGA AS DISCIPLINAS QUE FORAM RESPONDIDAS CORRETAMENTE ao clicar em resumo ,PARA PODER RENDERIZAR NA accumulated_right no Widget animated_button_progress.dart
  List<String> getDisciplineOfQuestions(List<ModelQuestions> resultQuestions) {
    List<String> listDisciplines = [];
    try {
      if (resultQuestions.isNotEmpty) {
        for (var disciplines in resultQuestions) {
          listDisciplines.add(disciplines.discipline);
        }
      }
    } catch (e) {
      print('Erro ao buscar disciplinas: $e');
    }
    return listDisciplines.toSet().toList();
  }

  // faz a seleção dos assuntos e anos escolares selecionados e retorna um map com o assunto e ano escolar sem repetição, como feedbackdo que foi selecionado
  List<Map<String, dynamic>> showSubjectAndSchoolYearSelected(
      String subjects, String schoolYear) {
    List<Map<String, dynamic>> listAuxYearAndSubjectSelected = [];
    List<dynamic> listAux = [];
    Map<String, dynamic> listMap = {};
    listMap = {
      'schoolYear': schoolYear,
      'subjects': subjects,
    };
    listAuxYearAndSubjectSelected.add(listMap);
    final listJson =
        listAuxYearAndSubjectSelected.map((el) => jsonEncode(el)).toList();
    final setList = listJson.toSet().toList();
    listAux = setList.map((el) => jsonDecode(el)).toList();
    for (var el in listAux) {
      mapYearAndSubjectSelected.add(el);
    }

    print('mapYearAndSubjectSelected $mapYearAndSubjectSelected');
    return mapYearAndSubjectSelected;
  }

  // faz a consulta das quaestões corretas pelo mapYearAndSubjectSelected
  List<ModelQuestions> getResultQuestions(
      List<ModelQuestions> resultQuestionsCorrect,
      List<dynamic> mapYearAndSubjectSelected) {
    List<ModelQuestions> resultQuestions = [];
    try {
      for (var question in resultQuestionsCorrect) {
        for (var res in mapYearAndSubjectSelected) {
          if (question.subject == res['subjects'] &&
              question.schoolYear == res['schoolYear']) {
            resultQuestions.add(question);
          }
        }
      }
    } catch (e) {
      print('Erro ao buscar questões por assunto: $e');
    }
    print('resultQuestions $resultQuestions');
    return resultQuestions;
  }

  // Manda a disciplina e todas as questões corretas
  // faz a busca atraves da disciplina selecionada
  // retorna uma lista de map com assunto e ano escolar, sem repetição
  // mostra no expanted
  List<Map<String, dynamic>> showSubjectsAndSchoolyear(
      String discipline, List<ModelQuestions> resultQuestionsCorrects) {
    List<Map<String, dynamic>> mapListSubAndYearCorrects = [];
    Map<String, dynamic> mapYearAndSubject = {};
    List<Map<String, dynamic>> result = [];

    if (resultQuestionsCorrects.isNotEmpty) {
      for (var map in resultQuestionsCorrects) {
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
        mapListSubAndYearCorrects.add(listMap);
      }

      print('mapListSubAndYearCorrects $mapListSubAndYearCorrects');
    }
    return mapListSubAndYearCorrects;
  }

// contador das disciplinas respondidas
  List<Map<String, dynamic>> counterDiscipline(
      List<ModelQuestions> resultQuestionsCorrect) {
    List<Map<String, dynamic>> listAmountAnswered = [];

    List<String> portugues = [];
    List<String> matematica = [];
    List<String> geografia = [];
    List<String> historia = [];
    List<String> ciencias = [];

    for (var dis in resultQuestionsCorrect) {
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

    return listAmountAnswered;
  }
}
