import 'package:flutter/foundation.dart';
import 'package:admin_noribox_store/models/cliente.dart';
import 'package:admin_noribox_store/services/clientes_service.dart';

class ClientesController extends ChangeNotifier {
  final ClientesService service;
  ClientesController({required this.service});
  List<Cliente> clientes = [];
  bool isDeletado = false;

  Future<void> buscarClientesController() async {
    try {
      clientes = await service.buscarClientes();
      //print('Clientes recebidos: ${clientes[0]}');
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar clientes: $e');
      }
      throw Exception('Erro ao buscar clientes: $e');
    }
  }

  // Exemplo de uso no controller
  Future<void> deletarCliente(String id) async {
    try {
      isDeletado = await ClientesService().excluirCliente(id);
      notifyListeners();
    } catch (e) {
      // Trate o erro, exiba mensagem ao usuário
    }
  }
}
