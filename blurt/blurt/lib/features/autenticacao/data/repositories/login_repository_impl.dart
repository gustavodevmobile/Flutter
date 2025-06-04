import '../../../../models/usuario/usuario.dart';
import '../../domain/repositories/login_repository.dart';
import '../datasources/usuario/login_remote_datasource.dart';
import '../../../../models/usuario/usuario_model.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDatasource datasource;
  LoginRepositoryImpl(this.datasource);

  @override
  Future<Usuario> login(String email, String senha) async {
    final json = await datasource.login(email, senha);
    return UsuarioModel.fromJson(json);
  }
}
