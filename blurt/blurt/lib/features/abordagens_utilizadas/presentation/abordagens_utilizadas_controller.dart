import 'package:flutter/material.dart';
import '../data/abordagens_utilizadas_datasource.dart';
import 'package:blurt/models/abordagens_utilizadas/abordagens_utilizadas.dart';

class AbordagensUtilizadasController extends ChangeNotifier {
  final AbordagensUtilizadasDatasource datasource;
  AbordagensUtilizadasController(this.datasource);

  List<AbordagensUtilizadas> abordagensUtilizadas = [];

  Future<void> buscarAbordagensUtilizadas() async {
    abordagensUtilizadas = await datasource.buscarAbordagensUtilizadas();
    notifyListeners();
  }
}
