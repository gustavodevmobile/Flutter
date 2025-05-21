import 'package:http/http.dart';
import 'package:t_acolhe/service/api_service.dart';

class LoginController {
  final ApiService _apiService = ApiService();

  Future<Response> loginUsuario({
    required String email,
    required String senha,
  }) async {
    try {
      return await _apiService.loginUsuario(email, senha);
    } on Exception catch (e) {
      rethrow;
    }
  }

  Future<Response> loginProfissional({
    required String cpf,
    required String senha,
  }) async {
    try {
      return await _apiService.loginProfissional(cpf, senha);
    } on Exception catch (e) {
      print('Erro ao fazer login: $e');
      rethrow;
    }
  }
}
