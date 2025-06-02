// import 'dart:convert';

// import 'package:blurt/controller/buscas_controller.dart';
// import 'package:http/http.dart';
// import 'package:blurt/models/professional.dart';
// import 'package:blurt/models/usuario.dart';
// import 'package:blurt/service/api_service.dart';

// class LoginController {
//   final ApiService _apiService = ApiService();
//   final BuscasController _buscas = BuscasController();

//   Future<void> loginUsuario(String email, String senha,
//       Function(Usuario) usuario, Function(String) onError) async {
//     try {
//       Response response = await _apiService.loginUsuario(email, senha);
//       if (response.statusCode == 200) {
//         final result = jsonDecode(response.body);
//         usuario(Usuario.fromJson(result));
//       } else {
//         onError(response.body);
//       }
//     } catch (e) {
//       print('Erro ao fazer login: $e');
//       onError('Erro ao fazer login: $e');
//     }
//   }

//   Future<void> logoutProfissional(
//       String id, Function(String) onSuccess, Function(String) onError) async {
//     print(id);
//     try {
//       Response response = await _apiService.logoutProfissional(id);
//       if (response.statusCode == 200) {
//         onSuccess(response.body);
//       } else {
//         onError(response.body);
//       }
//     } catch (e) {
//       onError('Erro ao fazer login: $e');
//     }
//   }

//   Future<void> loginProfissional(
//     String cpf,
//     String senha,
//     Function(Professional) onSuccess,
//     Function(String) onError,
//   ) async {
//     try {
//       Response response = await _apiService.loginProfissional(cpf, senha);
//       if (response.statusCode == 200) {
//         final result = jsonDecode(response.body);

//         // Função para capitalizar a primeira letra
//         String capitalize(String? s) {
//           if (s == null || s.isEmpty) return '';
//           return s[0].toUpperCase() + s.substring(1);
//         }

//         // Capitalizar abordagemPrincipal
//         if (result['abordagemPrincipal'] != null) {
//           result['abordagemPrincipal'] =
//               capitalize(result['abordagemPrincipal']);
//         }

//         // Capitalizar cada item de abordagensUtilizadas
//         if (result['abordagensUtilizadas'] is List) {
//           result['abordagensUtilizadas'] =
//               (result['abordagensUtilizadas'] as List)
//                   .map((e) => capitalize(e.toString()))
//                   .toList();
//         }

//         // Capitalizar especialidadePrincipal
//         if (result['especialidadePrincipal'] != null) {
//           result['especialidadePrincipal'] =
//               capitalize(result['especialidadePrincipal']);
//         }

//         // Capitalizar cada nome em temasClinicos (se for lista de objetos)
//         if (result['temasClinicos'] is List) {
//           result['temasClinicos'] = (result['temasClinicos'] as List)
//               .map((e) => capitalize(e.toString()))
//               .toList();
//         }
//         print('Profissional: ${result['nome']}');

//         onSuccess(Professional.fromJson(result));
//       } else {
//         onError('Erro ao fazer login do profissional: ${response.body}');
//       }
//     } catch (e) {
//       print('Erro ao fazer login do profissional: $e');
//       onError('Erro ao fazer login do profissional: $e');
//     }
//   }

//   // Future<Response> loginProfissional({
//   //   required String cpf,
//   //   required String senha,
//   // }) async {
//   //   try {
//   //     return await _apiService.loginProfissional(cpf, senha);
//   //   } on Exception catch (e) {
//   //     print('Erro ao fazer login: $e');
//   //     rethrow;
//   //   }
//   // }
// }
