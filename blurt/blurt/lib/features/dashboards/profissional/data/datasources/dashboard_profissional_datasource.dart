// Fonte de dados remota para dashboard
abstract class DashboardProfissionalDatasource {
  Future<List<Map<String, dynamic>>> buscarSessoes(String userId);
  Future<String> alterarStatusAtendePlantao({
    required String profissionalId,
    required bool novoStatus,
  });
  Future<String> logoutProfissional({
    required String profissionalId,
  });
}
