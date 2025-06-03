import 'package:blurt/shared/profissional/profissional.dart';

abstract class ProfissionaisOnlineRepository {
  /// Obtém a lista de profissionais online.
  Future<List<Profissional>> buscarProfissionaisOnline();

}