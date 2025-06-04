import 'package:blurt/models/especialidade_principal/especialidade_principal.dart';
import 'package:flutter/material.dart';

import '../data/especialidade_principal_datasource.dart';

class EspecialidadePrincipalController extends ChangeNotifier {
  final EspecialidadePrincipalDatasource datasource;
  EspecialidadePrincipalController(this.datasource);

  List<EspecialidadePrincipal> especialidadesPrincipais = [];

  Future<void> buscarEspecialidadesPrincipais() async {
    especialidadesPrincipais =
        await datasource.buscarEspecialidadesPrincipais();
    notifyListeners();
  }
}
