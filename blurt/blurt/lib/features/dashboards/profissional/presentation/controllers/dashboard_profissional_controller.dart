import 'package:blurt/features/dashboards/profissional/data/datasources/dashboard_profissional_datasource.dart';
import 'package:flutter/material.dart';

class DashboardProfissionalController extends ChangeNotifier {
  final DashboardProfissionalDatasource datasource;
  DashboardProfissionalController(this.datasource);

  Future<String> alterarStatusAtendePlantao({
    required String profissionalId,
    required bool novoStatus,
  }) async {
    return await datasource.alterarStatusAtendePlantao(
      profissionalId: profissionalId,
      novoStatus: novoStatus,
    );
  }

  Future<String> logoutProfissional({
    required String profissionalId,
  }) async {
    return await datasource.logoutProfissional(profissionalId: profissionalId);
  }
}
