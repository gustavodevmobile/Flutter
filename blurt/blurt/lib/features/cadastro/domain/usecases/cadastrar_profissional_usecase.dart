import 'package:blurt/features/cadastro/data/repositories/cadastro_profissional_repository_impl.dart';
import 'package:blurt/models/profissional/profissional.dart';

class CadastrarProfissionalUseCase {
  final CadastroProfissionalRepositoriesImpl repository;
  CadastrarProfissionalUseCase(this.repository);

  Future<String> call(Profissional profissional) async {
    final prof = await repository.cadastrarProfissional(profissional);
    return prof;
  }
}
