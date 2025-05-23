import 'dart:convert';
import 'package:t_acolhe/models/especialidade_abordagem.dart';

import '../service/api_service.dart';

class AbordagemEspecialidadeController {
  final ApiService _apiService = ApiService();

  Future<List<String>> buscarAbordagens() async {
    final response = await _apiService.getAbordagens();
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map<String>((item) => item['nome'] as String).toList();
    } else {
      throw Exception('Erro ao buscar abordagens');
    }
  }

  Future<List<Especialidade>> buscarEspecialidades() async {
    final response = await _apiService.getEspecialidades();
    List<Especialidade> especialidades = [];
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      for(var item in data) {
        final  esp = Especialidade.fromJson(item);
        especialidades.add(esp);
      }
      return especialidades;
      //return data.map<String>((item) => item['nome'] as String).toList();
    } else {
      throw Exception('Erro ao buscar especialidades');
    }
  }
}
