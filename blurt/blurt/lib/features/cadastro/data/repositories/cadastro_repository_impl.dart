// // Implementação do repositório de cadastro
// import '../../domain/entities/profissional.dart';
// import '../../domain/repositories/cadastro_repository.dart';
// import '../datasources/cadastro_remote_datasource.dart';
// import '../models/profissional_model.dart';

// class CadastroRepositoryImpl implements CadastroRepository {
//   final CadastroRemoteDatasource datasource;
//   CadastroRepositoryImpl(this.datasource);

//   @override
//   Future<Profissional> cadastrar(Map<String, dynamic> data) async {
//     final model = await datasource.cadastrar(data);
//     return ProfissionalModel.fromJson(model);
//   }
// }
