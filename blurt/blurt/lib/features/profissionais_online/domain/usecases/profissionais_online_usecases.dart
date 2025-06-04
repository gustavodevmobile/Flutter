import 'package:blurt/features/profissionais_online/data/repositories/profissionais_online_impl.dart';
import 'package:blurt/models/profissional/profissional.dart';

class ProfissionaisOnlineUsecases {
  ProfissionaisOnLineImpl repository;
  ProfissionaisOnlineUsecases(this.repository);

  Future<List<Profissional>> getOnlineProfissionais() {
    return repository.buscarProfissionaisOnline();
  }
}
