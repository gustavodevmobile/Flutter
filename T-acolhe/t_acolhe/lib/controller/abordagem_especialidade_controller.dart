import 'dart:convert';
import 'package:t_acolhe/models/especialidade_abordagem.dart';

import '../service/api_service.dart';

class AbordagemEspecialidadeController {
  final ApiService _apiService = ApiService();

  Future<List<Abordagem>> buscarAbordagens() async {
    final response = await _apiService.getAbordagens();
    List<Abordagem> abordagens = [];
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      for (var item in data) {
        final abord = Abordagem.fromJson(item);
        abordagens.add(abord);
      }
      return abordagens;
    } else {
      throw Exception('Erro ao buscar abordagens');
    }
  }

  Future<List<Especialidade>> buscarEspecialidades() async {
    final response = await _apiService.getEspecialidades();
    List<Especialidade> especialidades = [];
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      for (var item in data) {
        final esp = Especialidade.fromJson(item);
        especialidades.add(esp);
      }
      return especialidades;
    } else {
      throw Exception('Erro ao buscar especialidades');
    }
  }
}
