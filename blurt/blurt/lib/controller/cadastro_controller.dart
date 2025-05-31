import '../service/api_service.dart';
import 'package:http/http.dart';
import '../models/professional.dart';

class CadastroController {
  final ApiService _apiService = ApiService();

  Future<Response> cadastrarUsuario({
    required String nome,
    required DateTime dataNascimento,
    required String email,
    required String telefone,
    required String senha,
    required String cpf,
    required String genero,
  }) async {
    final data = {
      'nome': nome,
      'dataNascimento': dataNascimento.toIso8601String(),
      'email': email,
      'telefone': telefone,
      'senha': senha,
      'cpf': cpf,
      'genero': genero,
    };
    try {
      return await _apiService.cadastrarUsuario(data);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // Future<Response> cadastrarProfissional({
  //   required String nome,
  //   required String email,
  //   required String senha,
  //   required String bio,
  //   required String cpf,
  //   required String cnpj,
  //   required String registroProfissional,
  //   required String tipoProfissional,
  //   required String genero,
  //   required String valorConsulta,
  // }) async {
  //   final data = {
  //     'nome': nome,
  //     'email': email,
  //     'senha': senha,
  //     'bio': bio,
  //     'cpf': cpf,
  //     'cnpj': cnpj,
  //     'registro_profissional': registroProfissional,
  //     'tipo_profissional': tipoProfissional,
  //     'genero': genero,
  //     'valor_consulta': valorConsulta,
  //   };
  //   try {
  //     return await _apiService.cadastrarProfissional(data);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<Response> cadastrarProfissionalModel(Professional profissional) async {
    try {
      print('Cadastrando profissional: ${profissional.imagemSelfieComDoc}');
      final data = profissional.toJson();
      return await _apiService.cadastrarProfissional(data);
    } catch (e) {
      print('Erro ao cadastrar profissional: $e');
      rethrow;
    }
  }

  // Future<String> cadastrarAbordagemPrincipal(String nome) async {
  //   try {
  //     final response = await _apiService.cadastrarAbordagemPrincipal(nome);
  //     if (response.statusCode == 200) {
  //       return response.body; // Retorna o nome da abordagem cadastrada
  //     } else {
  //       throw Exception('Erro ao cadastrar abordagem: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // Future<String> cadastrarAbordagensUtilizadas(String nome) async {
  //   try {
  //     final response = await _apiService.cadastrarAbordagensUtilizadas(nome);
  //     if (response.statusCode == 200) {
  //       return response.body; // Retorna o nome da abordagem cadastrada
  //     } else {
  //       throw Exception('Erro ao cadastrar abordagem: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // Future<String> cadastrarEspecialidadePrincipal(
  //     String novaEspecialidade) async {
  //   try {
  //     final response =
  //         await _apiService.cadastrarEspecialidadePrincipal(novaEspecialidade);
  //     if (response.statusCode == 200) {
  //       return response.body;
  //     } else {
  //       throw Exception(
  //           'Erro ao cadastrar especialidades: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // Future<String> cadastrarEspecialidadeOutras(String novaEspecialidade) async {
  //   try {
  //     final response =
  //         await _apiService.cadastrarEspecialidadeOutras(novaEspecialidade);
  //     if (response.statusCode == 200) {
  //       return response.body;
  //     } else {
  //       throw Exception(
  //           'Erro ao cadastrar especialidades: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // Future<String> cadastrarTemasClinicos(String novoTema) async {
  //   try {
  //     final response = await _apiService.cadastrarTemasClinicos(novoTema);
  //     if (response.statusCode == 200) {
  //       return response.body; // Retorna o nome do tema clínico cadastrado
  //     } else {
  //       throw Exception(
  //           'Erro ao cadastrar tema clínico: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
