import 'package:blurt/models/usuario.dart';
import 'package:flutter/material.dart';
import '../models/professional.dart';

class ProviderController with ChangeNotifier {
  Professional? profissional;
  Usuario? usuario;
  List<Professional> profissionaisOnline = [];

  void setProfissional(Professional prof) {
    profissional = prof;
    notifyListeners();
  }

  void setUsuario(Usuario user) {
    usuario = user;
    notifyListeners();
  }

  void setProfissionaisOnline(List<Professional> profissionais) {
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
