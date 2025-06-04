import 'package:blurt/models/abordagem_principal/aboradagem_principal.dart';
import 'package:flutter/material.dart';
import '../data/abordagem_principal_datasource.dart';

class AbordagemPrincipalController extends ChangeNotifier {
  final AbordagemPrincipalDatasource datasource;
  AbordagemPrincipalController(this.datasource);

  List<AbordagemPrincipal> abordagensPrincipais = [];

  Future<void> buscarAbordagensPrincipais() async {
    abordagensPrincipais = await datasource.buscarAbordagensPrincipais();
    print('Abordagens principais carregadas: ${abordagensPrincipais.length}');
    notifyListeners();
  }
}
