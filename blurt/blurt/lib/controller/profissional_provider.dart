import 'package:flutter/material.dart';
import '../models/professional.dart';

class ProfissionalProvider with ChangeNotifier {
  Professional? _profissional;
  List<Professional> _profissionaisOnline = [];

  List<Professional> get profissionaisOnline => _profissionaisOnline;
  Professional? get profissional => _profissional;

  void setProfissional(Professional profissional) {
    _profissional = profissional;
    notifyListeners();
  }

  void setProfissionaisOnline(List<Professional> profissionais) {
    if (profissionais.isNotEmpty) {
      _profissionaisOnline = profissionais;
    }
    notifyListeners();
  }



  void clear() {
    _profissional = null;
    notifyListeners();
  }
  void clearOnline() {
    _profissionaisOnline.clear();
    notifyListeners();
  }
}
