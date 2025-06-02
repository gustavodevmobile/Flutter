import '../entities/profissional.dart';
import '../repositories/cadastro_repository.dart';

class CadastrarProfissionalUseCase {
  final CadastroRepository repository;
  CadastrarProfissionalUseCase(this.repository);

  Future<Profissional> call(Map<String, dynamic> data) {
    return repository.cadastrar(data);
  }
}
