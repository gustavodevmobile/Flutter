import 'package:admin_noribox_store/models/categoria.dart';
import 'package:admin_noribox_store/services/categoria_service.dart';
import 'package:flutter/foundation.dart';

class CategoriaController extends ChangeNotifier {
  final CategoriaService service; // Injetado via construtor
  List<Categoria> categorias = [];
  CategoriaController({required this.service});

  Future<Categoria> cadastrarCategoriaController(String categoria) async {
    notifyListeners();
    try {
      final result = await service.cadastrarCategoria(categoria);
      print('Categoria cadastrada: $result');
      notifyListeners();
      return result;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> buscarCategoriaController() async {
    try {
      categorias = await service.buscarCategorias();
      notifyListeners();
    } catch (error) {
      throw Exception('Erro ao buscar produtos: $error');
    }
  }
}
