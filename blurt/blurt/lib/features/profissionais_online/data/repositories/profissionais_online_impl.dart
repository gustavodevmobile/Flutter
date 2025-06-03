import 'package:blurt/features/profissionais_online/data/datasources/profissionais_online_datasource.dart';
import 'package:blurt/features/profissionais_online/domain/repositories/profissionais_online.dart';
import 'package:blurt/shared/profissional/profissional_model.dart';
import '../../../../shared/profissional/profissional.dart';

class ProfissionaisOnLineImpl implements ProfissionaisOnlineRepository {
  final ProfissionaisOnlineDatasoure datasource;
  ProfissionaisOnLineImpl(this.datasource);

  @override
  Future<List<Profissional>> buscarProfissionaisOnline() async {
    final jsonList = await datasource.buscarProfissionaisOnline();
    return jsonList.map((json) => ProfissionalModel.fromJson(json)).toList();
  }
}
