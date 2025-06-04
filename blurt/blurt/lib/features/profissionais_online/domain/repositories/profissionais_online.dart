import 'package:blurt/models/profissional/profissional.dart';

abstract class ProfissionaisOnlineRepository {
  /// Obtém a lista de profissionais online.
  Future<List<Profissional>> buscarProfissionaisOnline();

}