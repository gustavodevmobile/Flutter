import '../entities/sessao.dart';

abstract class DashboardRepository {
  Future<List<Sessao>> buscarSessoes(String userId);
}
