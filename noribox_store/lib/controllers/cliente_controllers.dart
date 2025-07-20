import 'package:flutter/material.dart';
import 'package:noribox_store/models/endereco_usuario_,model.dart';
import 'package:noribox_store/models/usuario_model.dart';
import 'package:noribox_store/service/cliente_service.dart';

class ClienteControllers extends ChangeNotifier {
  final ClienteService clienteService;
  ClienteControllers({required this.clienteService});

  Map<String, dynamic>? enderecoUsuario;
  String? erroCep;
  bool existsEmail = false;

  Future<void> buscarEnderecoPorCep(String cep) async {
    erroCep = null;
    if (cep.replaceAll(RegExp(r'[^0-9]'), '').length != 8) {
      erroCep = 'CEP inválido';
      enderecoUsuario = null;
      notifyListeners();
      return;
    }
    try {
      enderecoUsuario = await clienteService.buscarEnderecoPorCep(cep);
      erroCep = null;
      notifyListeners();
    } catch (e) {
      enderecoUsuario = null;
      erroCep = e
          .toString()
          .replaceAll('Exception: ', ''); // Remove "Exception: " se vier
      notifyListeners();
    }
  }

  Future<void> verificarEmailController(String email) async {
    try {
      existsEmail = await clienteService.verificarEmail(email);
      notifyListeners();
    } catch (e) {
      print('Erro ao verificar e-mail: $e');
      rethrow;
      //notifyListeners();
    }
  }

  Future<Map<String, dynamic>> cadastrarClienteController(
      ClienteModel cliente) async {
    try {
      return await clienteService.cadastrarCliente(cliente);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> cadastrarEnderecoController(
      EnderecoClienteModel endereco) async {
    try {
      return await clienteService.cadastrarEnderecoCliente(endereco);
    } catch (e) {
      rethrow;
    }
  }
}
