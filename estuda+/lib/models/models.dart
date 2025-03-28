import 'package:flutter/material.dart';

class ModelPoints extends ChangeNotifier {
  double boxIsAnswered = 0;
  bool isAnswered = false;
  bool actionBtnCircle = false;
  bool actionBtnRetangulare = false;
  bool progressError = false;
  bool showBoxSubjects = false;
  String answeredsCurrents = '';
  String correctsCurrents = '';
  String incorrectsCurrents = '';
  List<String> listDisciplines = [];
  bool hasConnection = false;

  void actBoxAnswered(double active) {
    boxIsAnswered = active;
    notifyListeners();
  }

  void answered(bool act) {
    isAnswered = act;
    notifyListeners();
  }

  void showSubjects(bool show) {
    showBoxSubjects = show;
    notifyListeners();
  }

  void enableBtnRetangulare(bool value) {
    actionBtnRetangulare = value;
    notifyListeners();
  }

  void answeredsAmount(String amount) {
    answeredsCurrents = amount;
    notifyListeners();
  }

  void answeredsCorrects(String amount) {
    correctsCurrents = amount;
    notifyListeners();
  }

  void answeredsIncorrects(String amount) {
    incorrectsCurrents = amount;
    notifyListeners();
  }

  void getListDisciplines(List<String> listDis) {
    listDisciplines = listDis;
    notifyListeners();
  }

  void isConnected(bool value) {
    hasConnection = value;
    notifyListeners();
  }
}
