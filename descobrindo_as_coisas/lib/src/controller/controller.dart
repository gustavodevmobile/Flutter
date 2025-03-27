import 'package:descobrindo_as_coisas/src/controller/counter.dart';
import 'package:descobrindo_as_coisas/src/controller/states.dart';
import 'package:flutter/material.dart';

class Controller extends ChangeNotifier {
  bool isAccepted;
  double bordeCards;
  bool isBorder;
  static List<String> compare = [];
  static List<String> identifyLetter = [];
  String hours;
  String minutes;
  String seconds;
  bool isActivity;

  Controller({
    this.isAccepted = false,
    this.isBorder = false,
    this.bordeCards = 0,
    this.hours = '00',
    this.minutes = '00',
    this.seconds = '00',
    this.isActivity = false,
  });

  States states = States();

  void changeAccepted(bool value) {
    isAccepted = value;
    notifyListeners();
  }

  void changeBorderCards(double value) {
    bordeCards = value;
    notifyListeners();
  }

  void changeBorder(bool value) {
    isBorder = value;
    notifyListeners();
  }

  void addCompare(String card) {
    compare.add(card);
    notifyListeners();
  }

  void addIdentifyLetter(String letter) {
    identifyLetter.add(letter);
    notifyListeners();
  }

  void resetController() {
    Counter.count = 0;
    states.isMatch = false;
    states.isFlipped = true;
    compare.clear();
    identifyLetter.clear();
    Counter.matchs = 0;
    print('controle resetado!');
  }

  void timerFinal(String hr, String min, String seg) {
    hours = hr;
    minutes = min;
    seconds = seg;
    print('$hours, $minutes, $seconds');
    notifyListeners();
  }
  void timerActivity(bool value) {
    isActivity = value;
    notifyListeners();
  }
}
