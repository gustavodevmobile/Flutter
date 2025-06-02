import '../../domain/usecases/buscar_sessoes_usecase.dart';
import 'package:flutter/material.dart';

class DashboardController extends ChangeNotifier {
  final BuscarSessoesUseCase buscarSessoesUseCase;
  DashboardController(this.buscarSessoesUseCase);
  // Implemente métodos de dashboard e estado aqui
}
