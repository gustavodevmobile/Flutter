import '../../../../shared/profissional/profissional.dart';
import '../../domain/repositories/login_profissional_repository.dart';
import '../datasources/login_profissional_remote_datasource.dart';
import '../../../../shared/profissional/profissional_model.dart';

class LoginProfissionalRepositoryImpl implements LoginProfissionalRepository {
  final LoginProfissionalRemoteDatasource datasource;
  LoginProfissionalRepositoryImpl(this.datasource);

  @override
  Future<Profissional> login(String cpf, String senha) async {
    final json = await datasource.login(cpf, senha);
    return ProfissionalModel.fromJson(json);
  }
}
