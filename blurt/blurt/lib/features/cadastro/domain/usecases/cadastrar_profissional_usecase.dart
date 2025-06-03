import 'package:blurt/shared/profissional/profissional.dart';
import '../repositories/cadastro_profissional_repository.dart';

class CadastrarProfissionalUseCase {
  final CadastroProfissionalRepository repository;
  CadastrarProfissionalUseCase(this.repository);

  Future<Profissional> call(Map<String, dynamic> data) {
    return repository.cadastrarProfissional(data);
  }
}
