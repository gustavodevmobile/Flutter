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
  MemoryImage? fotoDecodificada;

  // Novo: cache de imagens dos profissionais online
  final Map<String, MemoryImage> fotosProfissionaisOnline = {};

  void setProfissional(Profissional prof) {
    profissional = prof;
    if (profissional?.foto != null) {
      fotoDecodificada = MemoryImage(base64Decode(profissional!.foto));
      notifyListeners();
    } else {
      fotoDecodificada = null;
    }
    notifyListeners();
  }

  void setUsuario(Usuario user) {
    usuario = user;
    notifyListeners();
  }

  void setProfissionaisOnline(List<Profissional> profissionais) {
    if (profissionais.isNotEmpty) {
      profissionaisOnline = profissionais;
      for (var prof in profissionais) {
        fotosProfissionaisOnline[prof.id!] =
            MemoryImage(base64Decode(prof.foto));
      }
    }
    print('fotosProfissionaisOnline: $fotosProfissionaisOnline');
    notifyListeners();
  }

  MemoryImage? getFotoProfissional(String id) {
    return fotosProfissionaisOnline[id];
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
