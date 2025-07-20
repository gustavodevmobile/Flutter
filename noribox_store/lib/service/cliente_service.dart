import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:noribox_store/models/endereco_usuario_,model.dart';
import 'package:noribox_store/models/usuario_model.dart';

class ClienteService {
  final urlServidor = '${dotenv.env['API_URL']}';

  Future<Map<String, dynamic>?> buscarEnderecoPorCep(String cep) async {
    final uri = Uri.parse('https://brasilapi.com.br/api/cep/v1/$cep');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Se vier o campo 'cep', é sucesso
      if (data.containsKey('cep')) {
        return {
          "cep": data['cep'],
          "estado": data['state'],
          "cidade": data['city'],
          "bairro": data['neighborhood'],
          "rua": data['street'],
        };
      }

      // Se vier o campo 'message', é erro
      if (data.containsKey('message')) {
        throw Exception('CEP inválido');
      }
    }

    throw Exception('CEP inválido');
  }

  Future<bool> verificarEmail(String email) async {
    try {
      final uri =
          Uri.parse('$urlServidor/clientes/verificar-email?email=$email');

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
        //body: jsonEncode({'email': email}),
      );
      print('Verificando e-mail: $email');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Resposta do servidor: $data');
        return data['existe'] as bool;
      } else {
        throw Exception('Erro ao verificar e-mail');
      }
    } catch (e) {
      print('Erro ao verificar e-mail: $e');
      throw Exception('Erro ao verificar e-mail: $e');
    }
  }

  Future<Map<String, dynamic>> cadastrarCliente(ClienteModel cliente) async {
    final uri = Uri.parse('$urlServidor/clientes/cadastro-dados-pessoais');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(cliente.toJson()),
    );
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return {
        'id': data['id'],
      };
    } else {
      final error = jsonDecode(response.body);
      throw Exception('${error['error'] ?? 'Erro desconhecido'}');
    }
  }

  Future<String> cadastrarEnderecoCliente(EnderecoClienteModel endereco) async {
    final uri = Uri.parse('$urlServidor/clientes/cadastro-endereco');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(endereco.toJson()),
    );
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['message'] ?? 'Endereço cadastrado com sucesso!';
    } else {
      print('Erro ao cadastrar endereço: ${response.body}');
      final error = jsonDecode(response.body);
      throw Exception('${error['error'] ?? 'Erro desconhecido'}');
    }
  }
}
