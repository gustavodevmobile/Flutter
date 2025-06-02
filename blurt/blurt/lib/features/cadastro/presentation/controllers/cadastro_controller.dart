import '../../domain/usecases/cadastrar_profissional_usecase.dart';
import 'package:flutter/material.dart';

class CadastroController extends ChangeNotifier {
  final CadastrarProfissionalUseCase cadastrarUseCase;
  CadastroController(this.cadastrarUseCase);
  // Implemente métodos de cadastro e estado aqui
}
