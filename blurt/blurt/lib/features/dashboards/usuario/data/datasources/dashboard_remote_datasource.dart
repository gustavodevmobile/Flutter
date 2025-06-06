// Fonte de dados remota para dashboard
abstract class DashboardRemoteDatasource {
  Future<List<Map<String, dynamic>>> buscarSessoes(String userId);
}
