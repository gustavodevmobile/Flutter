import 'package:flutter/material.dart';
import 'package:noribox_store/service/produtos_service.dart';
import 'package:noribox_store/models/produtos_models.dart';

class ProdutosController extends ChangeNotifier {
  final ProdutosService service;

  ProdutosController({required this.service});

  Future<List<Produto>> buscarProdutos() async {
    return await service.buscarProdutos();
  }
}
