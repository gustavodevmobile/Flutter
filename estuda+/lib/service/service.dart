// 1 - NO DRAWER da home, É SELECIONADO A DISCIPLINA DESEJADA, O MÉTODO getQuestionsByDiscipline BUSCA TODAS AS QUESTÕES DA DISCIPLINA SELECIONADA E ARMAZENADA NA LIST questionsByDiscipline;

// 2 - NA SCREEN schoolYear.dart, SELECIONA-SE OS ANOS DA DISCIPLINA E O MÉTODO getSubjectsOfDisciplineAndSchoolYear BUSCA TODOS OS 'ASSUNTOS' DA DISCIPLINA E DO ANO SELECIONADOS;

// 3 - NA SCREEN subject.dart, SELECIONA-SE OS ASSUNTOS DESEJADOS E O MÉTODO getQuestionsAllBySubjectsAndSchoolYear BUSCA TODAS AS QUESTÕES DO ANO E DO ASSUNTO SELECIONADOS EM questionsByDiscipline;

import 'dart:convert';
import 'package:estudamais/shared_preference/storage_shared_preferences.dart';
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

  Future<List<Map<String, dynamic>>> fetchSchoolYearByDisciplines(
      List<String> disciplines, Function(String) onError) async {
    List<String> ids = [];
    List<Map<String, dynamic>> idsAndschoolYear = [];
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
        print('list: $list');

        for (var obj in list) {
          idsAndschoolYear.add(obj);
        }
      } else if (response.statusCode == 408) {
        onError('Tempo de espera excedido.\nTente novamente mais tarde.');
      } else {
        onError('Erro ao buscar anos escolares: ${response.statusCode}');
      }
    } catch (e) {
      onError('Erro ao buscar anos escolares po disciplinas: $e');
    }
    return idsAndschoolYear;
  }

  /// Método para buscar os assuntos de uma disciplina e ano escolar selecionados e retorna-los em uma lista de List<Map<String, dynamic>> contendo os anos escolares, as disciplinas e os assuntos correspondentes.
  /// Esse método faz uma requisição HTTP POST para o servidor, enviando as disciplinas e os anos escolares selecionados. O servidor retorna uma lista de assuntos correspondentes às disciplinas e anos escolares selecionados.
  /// Caso ocorra algum erro durante a requisição, o método chama a função onError para exibir uma mensagem de erro.
  Future<List<Map<String, dynamic>>> fetchSubjectsByDisciplineAndSchoolYear(
      List<String> disciplines,
      List<String> schoolYear,
      Function(String) onError) async {
    List<Map<String, dynamic>> listSubjects = [];

    try {
      http.Response response = await http
          .post(
        Uri.parse('$_questoesAll/disciplines/schoolyears/subjects'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'disciplines': disciplines,
          'schoolYear': schoolYear,
        }),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        // Retorna uma resposta de timeout com status 408
        return http.Response("Timeout", 408);
      });

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
    print('Assuntos recebidos com sucesso: $listSubjects');

    return listSubjects;
  }

  /// Método para buscar questões de uma lista de assuntos, disciplinas e anos escolares selecionados. Ele faz uma requisição HTTP POST para o servidor, enviando os assuntos, disciplinas e anos escolares selecionados. O servidor retorna uma lista de questões correspondentes.
  Future<List<ModelQuestions>> fetchQuestions(
      List<Map<String, dynamic>> listMapSubjectsAndSchoolYear,
      Function(String) onError) async {
    List<ModelQuestions> questions = [];

    try {
      // Serializa a lista para JSON
      final body = jsonEncode(listMapSubjectsAndSchoolYear);
      print('body: $body');
      // Faz a requisição POST
      final response = await http
          .post(
        Uri.parse('$_questoesAll/resultadodabusca'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        return http.Response("Timeout", 408);
      });

      // Verifica o status da resposta
      if (response.statusCode == 200) {
        // Decodifica o corpo da resposta
        final List<dynamic> responseData = json.decode(response.body);

        for (var question in responseData) {
          // Converte os dados da imagem para Uint8List

          Uint8List bytesImage =
              Uint8List.fromList(question['image']['data'].cast<int>());
          question['image'] = bytesImage;

          // Adiciona o objeto convertido à lista de questões e converte os dados para uma lista de ModelQuestions
          questions.add(ModelQuestions.toMap(question));
        }
        print('questions: $questions');
      } else if (response.statusCode == 408) {
        onError('Tempo de espera excedido. Tente novamente mais tarde.');
      } else {
        onError('${response.body}: ${response.statusCode}');
      }
    } catch (e) {
      onError('Erro ao buscar questões: $e');
    }

    return questions;
  }
}
