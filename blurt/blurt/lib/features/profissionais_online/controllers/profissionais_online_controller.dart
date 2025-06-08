import 'package:flutter/material.dart';
import 'package:blurt/features/profissionais_online/domain/usecases/profissionais_online_usecases.dart';
import 'package:blurt/models/profissional/profissional.dart';

class ProfissionaisOnlineController extends ChangeNotifier {
  final ProfissionaisOnlineUsecases usecase;
  ProfissionaisOnlineController(this.usecase);

  Future<List<Profissional>> buscarProfissionaisOnline() async {
    try {
      final profissionais = await usecase.getOnlineProfissionais();
      notifyListeners();
      return profissionais;
    } catch (e) {
      print('Erro ao buscar profissionais online: $e');
      rethrow;
    }
  }
}
