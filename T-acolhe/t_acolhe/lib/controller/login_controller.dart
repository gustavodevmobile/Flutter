import 'dart:convert';

import 'package:http/http.dart';
import 'package:t_acolhe/models/professional.dart';
import 'package:t_acolhe/service/api_service.dart';

class LoginController {
  final ApiService _apiService = ApiService();

  Future<void> loginUsuario(String email, String senha, Function response,
      Function(String) onError) async {
    try {
      Response response = await _apiService.loginUsuario(email, senha);
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        //print(result['cpf']);
      } else {
        onError('Erro ao fazer login: ${response.body}');
      }
    } catch (e) {
      onError('Erro ao fazer login: $e');
    }
  }

  Future<void> loginProfissional(String cpf, String senha,
      Function(Professional) onSuccess, Function(String) onError) async {
    try {
      Response response = await _apiService.loginProfissional(cpf, senha);
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final professionalData = Professional.fromJson(result);
        onSuccess(professionalData);
      } else {
        onError('Erro ao fazer login: \\${response.body}');
      }
    } catch (e) {
      onError('Erro ao fazer login: $e');
    }
  }

  // Future<Response> loginProfissional({
  //   required String cpf,
  //   required String senha,
  // }) async {
  //   try {
  //     return await _apiService.loginProfissional(cpf, senha);
  //   } on Exception catch (e) {
  //     print('Erro ao fazer login: $e');
  //     rethrow;
  //   }
  // }
}
