import 'package:blurt/models/profissional/profissional.dart';

abstract class CadastroProfissionalRepositories {
  Future<String> cadastrarProfissional(Profissional profissional);
}
