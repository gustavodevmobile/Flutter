import 'dart:convert';

import 'package:blurt/models/profissional/profissional.dart';
import 'package:blurt/models/usuario/usuario.dart';
import 'package:flutter/material.dart';

class ProviderController with ChangeNotifier {
  Profissional? profissional;
  Usuario? usuario;
  List<Profissional> profissionaisOnline = [];
  bool online = false;
  bool plantao = false;
  bool isForeground = true;

  void setProfissional(Profissional prof) {
    profissional = prof;

    notifyListeners();
  }

  void setUsuario(Usuario user) {
    usuario = user;
    notifyListeners();
  }

  void setProfissionaisOnline(List<Profissional> profissionais) {
    if (profissionais.isNotEmpty) {
      profissionaisOnline = profissionais;
    }

    notifyListeners();
  }

  void clearUsuario() {
    usuario = null;
    notifyListeners();
  }

  void clearOnline() {
    profissionaisOnline.clear();
    notifyListeners();
  }

  void setOnline(bool value) {
    online = value;
    notifyListeners();
  }

  void setPlantao(bool value) {
    plantao = value;
    notifyListeners();
  }
}
