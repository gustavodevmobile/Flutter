import 'dart:convert';

import 'package:blurt/models/professional.dart';
import 'package:blurt/service/api_service.dart';
import 'package:http/http.dart';

class BuscasController {
  final ApiService _apiService = ApiService();

  Future<void> getProfissionalOnline(
      Function(List<Professional>) profissionais, Function(String) onError) async {
    try {
      Response response = await _apiService.getProfissionalOnline();
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        print('Profissionais online: $result');
        profissionais(
          (result as List).map((e) => Professional.fromJson(e)).toList(),
        );

      } else {
        onError('Erro ao buscar profissionais online: ${response.body}');
      }
    } on Exception catch (e) {
      onError('Erro ao buscar profissionais online: $e');
      rethrow;
    }
  }
}
