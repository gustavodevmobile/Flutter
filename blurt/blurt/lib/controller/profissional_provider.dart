import 'package:flutter/material.dart';
import '../models/professional.dart';

class ProfissionalProvider with ChangeNotifier {
  Professional? _profissional;

  Professional? get profissional => _profissional;

  void setProfissional(Professional profissional) {
    _profissional = profissional;
    notifyListeners();
  }

  void clear() {
    _profissional = null;
    notifyListeners();
  }
}
