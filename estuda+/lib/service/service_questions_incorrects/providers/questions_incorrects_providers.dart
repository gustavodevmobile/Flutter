import 'package:estudamais/models/model_questions.dart';
import 'package:flutter/material.dart';

class QuestionsIncorrectsProvider extends ChangeNotifier {
  List<ModelQuestions> resultQuestionsIncorrects = [];
  List<Map<String, dynamic>> listMapSubjectsAndSchoolYear = [];
  List<dynamic> subjectsAndSchoolYearSelected = [];
  List<Map<String, dynamic>> listDisciplinesAnswered = [];

  void questionsIncorrects(List<ModelQuestions> question) {
    resultQuestionsIncorrects = question;
    notifyListeners();
  }

  void subjectsAndSchoolYear(List<Map<String, dynamic>> listMap) {
    listMapSubjectsAndSchoolYear = listMap;
    notifyListeners();
  }

  void subjectAndSchoolYearSelected(List<dynamic> subjectsAndSchoolYear) {
    subjectsAndSchoolYearSelected = subjectsAndSchoolYear;
    notifyListeners();
  }

  void disciplinesAnswereds(List<Map<String, dynamic>> listMap) {
    listDisciplinesAnswered = listMap;
    notifyListeners();
  }
}
