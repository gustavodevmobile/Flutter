
import 'package:blurt/features/cadastro/data/datasources/profissional/cadastro_profissional_datasource_impl.dart';
import 'package:blurt/features/cadastro/domain/repositories/cadastro_Profissional_repository.dart';
import 'package:blurt/shared/profissional/profissional.dart';
import 'package:blurt/shared/profissional/profissional_model.dart';

class CadastroProfissionalRepositoryImpl implements CadastroProfissionalRepository {
  final CadastroProfissionalDatasourceImpl datasource;
  CadastroProfissionalRepositoryImpl(this.datasource);

  @override
  Future<Profissional> cadastrarProfissional(Map<String, dynamic> data) async {
    final model = await datasource.cadastrarProfissional(data);
    return ProfissionalModel.fromJson(model);
  }
}
