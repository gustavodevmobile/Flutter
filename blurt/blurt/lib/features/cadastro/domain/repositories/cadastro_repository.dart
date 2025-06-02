import '../entities/profissional.dart';

abstract class CadastroRepository {
  Future<Profissional> cadastrar(Map<String, dynamic> data);
}
