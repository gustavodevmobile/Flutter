import 'package:blurt/features/cadastro/data/datasources/profissional/cadastro_profissional_datasource_impl.dart';
import 'package:blurt/features/cadastro/domain/repositories/cadastro_profissional_repository.dart';
import 'package:blurt/models/profissional/profissional.dart';
import 'package:blurt/models/profissional/profissional_model.dart';

class CadastroProfissionalRepositoriesImpl
    implements CadastroProfissionalRepositories {
  final CadastroProfissionalDatasourceImpl datasource;
  CadastroProfissionalRepositoriesImpl(this.datasource);

  @override
  Future<String> cadastrarProfissional(Profissional profissional) async {
    final data = ProfissionalModel.fromProfissional(profissional).toJson();
    final prof = await datasource.cadastrarProfissional(data);

    return prof;
  }
}
