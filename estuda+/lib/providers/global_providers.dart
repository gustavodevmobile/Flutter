import 'package:estudamais/models/model_questions.dart';
import 'package:flutter/material.dart';

// Classe responsável por geranciar o estado
class GlobalProviders extends ChangeNotifier {
  bool isAnsweredBox = false;
  //bool isAnswered = false;
  bool actionBtnCircle = false;
  bool actionBtnRetangulare = false;
  bool progressError = false;
  bool showBoxSubjects = false;
  String answeredsCurrents = '';
  String correctsCurrents = '';
  String incorrectsCurrents = '';
  List<String> listDisciplines = [];
  bool hasConnection = false;
  List<ModelQuestions> resultQuestionsIncorrects = [];
  List<ModelQuestions> resultQuestionsCorrects = [];
  List<Map<String, dynamic>> listMapSubjectsAndSchoolYear = [];
  List<dynamic> subjectsAndSchoolYearSelected = [];
  List<Map<String, dynamic>> listDisciplinesAnsweredCorrects = [];
  List<Map<String, dynamic>> listDisciplinesAnsweredIncorrects = [];

  // Método responsável por atualizar o estado em abrir e fechar o AnimatedContainer caso a questão ja tenha sido respondida.
  void openBoxAlreadyAnswereds(bool value) {
    isAnsweredBox = value;
    notifyListeners();
  }
  
  // void handlerAnswereds(bool value) {
  //   isAnswered = value;
  //   notifyListeners();
  // }

  //Método responsável por habilitar e desabilitar o visualização dos assuntos selecionados nas telas das questões corretas e incorretas.
  void showSubjects(bool show) {
    showBoxSubjects = show;
    notifyListeners();
  }

  // Método responsável por fazer a consulta, caso esteja habilitado, add na lista as informações a serem consultadas, caso contrário, remove da lista o que deve ser consultado.
  void enableBtnRetangulare(bool value) {
    actionBtnRetangulare = value;
    notifyListeners();
  }

  // Método responsável por atualizar o estado da quantidade de questões responsidas.
  void answeredsAmount(String amount) {
    answeredsCurrents = amount;
    notifyListeners();
  }

// Método responsável por atualizar o estado da quantidade de questões corretas responsidas.
  void answeredsCorrects(String amount) {
    correctsCurrents = amount;
    notifyListeners();
  }

// Método responsável por atualizar o estado da quantidade de questões incorretas responsidas.
  void answeredsIncorrects(String amount) {
    incorrectsCurrents = amount;
    notifyListeners();
  }

// Método responsável por atualizar o estado das questões responsidas incorretamente.
  void questionsIncorrects(List<ModelQuestions> question) {
    resultQuestionsIncorrects = question;
    notifyListeners();
  }

// Método responsável por atualizar o estado das questões responsidas corretamente.
  void questionsCorrects(List<ModelQuestions> question) {
    resultQuestionsCorrects = question;
    notifyListeners();
  }
// Método responsável por atualizar o estado da lista de disciplinas.
  // void subjectsAndSchoolYea(List<Map<String, dynamic>> listMap) {
  //   listMapSubjectsAndSchoolYear = listMap;
  //   notifyListeners();
  // }

  void subjectAndSchoolYearSelected(
      Map<String, dynamic> subjectsAndSchoolYear) {
    if (!subjectsAndSchoolYearSelected.contains(subjectsAndSchoolYear)) {
      subjectsAndSchoolYearSelected.add(subjectsAndSchoolYear);
    }
    print('subjectsAndSchoolYearSelected $subjectsAndSchoolYearSelected');
    notifyListeners();
  }

  void disciplinesAnsweredsCorrects(List<Map<String, dynamic>> listMap) {
    listDisciplinesAnsweredCorrects = listMap;
    notifyListeners();
  }

  void disciplinesAnsweredsIncorrects(List<Map<String, dynamic>> listMap) {
    listDisciplinesAnsweredIncorrects = listMap;
    notifyListeners();
  }
}
