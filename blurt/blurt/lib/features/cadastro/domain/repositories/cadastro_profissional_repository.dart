import 'package:blurt/shared/profissional/profissional.dart';
abstract class CadastroProfissionalRepository {
  Future<Profissional> cadastrarProfissional(Map<String, dynamic> data);
}
