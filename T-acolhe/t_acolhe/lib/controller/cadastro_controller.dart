import '../service/api_service.dart';
import 'package:http/http.dart';
import '../models/professional.dart';

class CadastroController {
  final ApiService _apiService = ApiService();

  Future<Response> cadastrarUsuario({
    required String nome,
    required DateTime dataNascimento,
    required String email,
    required String senha,
    required String cpf,
    required String genero,
  }) async {
    final data = {
      'nome': nome,
      'dataNascimento': dataNascimento.toIso8601String(),
      'email': email,
      'senha': senha,
      'cpf': cpf,
      'genero': genero,
    };
    print('Data: $dataNascimento');
    try {
      return await _apiService.cadastrarUsuario(data);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Response> cadastrarProfissional({
    required String nome,
    required String email,
    required String senha,
    required String bio,
    required String cpf,
    required String cnpj,
    required String registroProfissional,
    required String tipoProfissional,
    required String genero,
    required String valorConsulta,
  }) async {
    final data = {
      'nome': nome,
      'email': email,
      'senha': senha,
      'bio': bio,
      'cpf': cpf,
      'cnpj': cnpj,
      'registro_profissional': registroProfissional,
      'tipo_profissional': tipoProfissional,
      'genero': genero,
      'valor_consulta': valorConsulta,
    };
    try {
      return await _apiService.cadastrarProfissional(data);
    } catch (e) {
     
      rethrow;
    }
  }

  

  // Future<Response> loginUsuario({
  //   required String email,
  //   required String senha,
  // }) async {
  //   try {
  //     return await _apiService.loginUsuario(email, senha);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<Response> cadastrarProfissionalModel(Professional profissional) async {
    try {
      return await _apiService.cadastrarProfissional(profissional.toJson());
    } catch (e) {
      rethrow;
    }
  }
}
