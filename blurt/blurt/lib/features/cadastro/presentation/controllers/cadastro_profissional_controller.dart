import 'package:flutter/material.dart';
import 'package:blurt/features/cadastro/domain/usecases/cadastrar_profissional_usecase.dart';
import 'package:blurt/models/profissional/profissional.dart';

class CadastroProfissionalController extends ChangeNotifier {
  final CadastrarProfissionalUseCase cadastrarUseCase;
  CadastroProfissionalController(this.cadastrarUseCase);

  Future<String> cadastrarProfissional(
      Profissional profissional) async {
    try {
      final result = await cadastrarUseCase(profissional);
      notifyListeners();
      return result;
    } catch (error) {
      notifyListeners();
      rethrow;
    }
  }
}
