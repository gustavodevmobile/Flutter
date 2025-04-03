import 'package:flutter/material.dart';

// Classe responsável por geranciar o estado
class GlobalProviders extends ChangeNotifier {
  bool isAnsweredBox = false;
  bool actionBtnCircle = false;
  bool actionBtnRetangulare = false;
  bool progressError = false;
  bool showBoxSubjects = false;
  String answeredsCurrents = '';
  String correctsCurrents = '';
  String incorrectsCurrents = '';
  List<String> listDisciplines = [];
  bool hasConnection = false;
  

  // Método responsável por atualizar o estado em abrir e fechar o AnimatedContainer caso a questão ja tenha sido respondida.
  void openBoxAlreadyAnswereds(bool value) {
    isAnsweredBox = value;
    notifyListeners();
  }

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
}
