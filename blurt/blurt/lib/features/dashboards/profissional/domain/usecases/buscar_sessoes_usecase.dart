import '../entities/sessao.dart';
import '../repositories/dashboard_repository.dart';

class BuscarSessoesUseCase {
  final DashboardRepository repository;
  BuscarSessoesUseCase(this.repository);

  Future<List<Sessao>> call(String userId) {
    return repository.buscarSessoes(userId);
  }
}
