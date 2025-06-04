import 'package:blurt/models/temas_clinicos/temas_clinicos_models.dart';

import '../data/temas_clinicos_datasource.dart';
import 'package:flutter/material.dart';

class TemasClinicosController extends ChangeNotifier {
  final TemasClinicosDatasource datasource;
  TemasClinicosController(this.datasource);

  List<TemasClinicos> temasClinicos = [];

  Future<void> buscarTemasClinicos() async {
    temasClinicos = await datasource.buscarTemasClinicos();
    notifyListeners();
  }
}
