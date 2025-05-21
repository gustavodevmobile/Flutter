import 'package:http/http.dart';
import '../service/api_service.dart';

class CadastroAbordagemEspecialidadeController {
  final ApiService _apiService = ApiService();

  Future<Response> cadastrarAbordagem(String nome) async {
    try {
      return await _apiService.cadastrarAbordagem(nome);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> cadastrarEspecialidades(List<String> nomes) async {
    try {
      return await _apiService.cadastrarEspecialidades(nomes);
    } catch (e) {
      rethrow;
    }
  }
}
