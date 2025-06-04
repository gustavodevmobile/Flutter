
import 'package:blurt/features/cadastro/data/datasources/usuario/cadastro_usuario_datasource_impl.dart';
import 'package:blurt/features/cadastro/domain/repositories/cadastro_usuario_repository.dart';
import 'package:blurt/models/usuario/usuario.dart';

import '../../../../models/usuario/usuario_model.dart';

class CadastroUsuarioRepositoriesImpl
    implements CadastroUsuarioRepositories {
  final CadastroUsuarioDatasourceImpl datasource;
  CadastroUsuarioRepositoriesImpl(this.datasource);

  @override
  Future<String> cadastrarUsuario(Usuario usuario) async {
    final data = UsuarioModel.fromUsuario(usuario).toJson();
    final prof = await datasource.cadastroUsuario(data);

    return prof;
  }
}
