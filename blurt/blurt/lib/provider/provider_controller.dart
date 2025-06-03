import 'package:blurt/models/usuario.dart';
import 'package:blurt/shared/profissional/profissional.dart';
import 'package:flutter/material.dart';
import '../models/professional.dart';

class ProviderController with ChangeNotifier {
  Profissional? profissional;
  Usuario? usuario;
  List<Profissional> profissionaisOnline = [];

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

  void clearProfissional() {
    profissional = null;
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
}
