// // Implementação do repositório de dashboard
// import '../../domain/entities/sessao.dart';
// import '../../domain/repositories/dashboard_repository.dart';
// import '../datasources/dashboard_remote_datasource.dart';
// import '../models/sessao_model.dart';

// class DashboardRepositoryImpl implements DashboardRepository {
//   final DashboardRemoteDatasource datasource;
//   DashboardRepositoryImpl(this.datasource);

//   @override
//   Future<List<Sessao>> buscarSessoes(String userId) async {
//     final list = await datasource.buscarSessoes(userId);
//     return list.map((json) => SessaoModel.fromJson(json)).toList();
//   }
// }
