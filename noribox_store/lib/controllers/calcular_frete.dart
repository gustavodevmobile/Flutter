import 'package:flutter/material.dart';
import 'package:noribox_store/service/calcular_frete_service.dart';

class CalcularFreteController with ChangeNotifier {
  final CalcularFreteService serviceFrete;
  CalcularFreteController({required this.serviceFrete});

  Future<List<Map<String, dynamic>>> calcularFrete({
    required String cepDestino,
    required List<Map<String, dynamic>> products,
  }) async {
    try {
      final resultado = await serviceFrete.calcularFrete(
        cepDestino: cepDestino,
        products: products,
      );
      return resultado;
    } catch (e) {
      debugPrint('Erro ao calcular frete: $e');
      rethrow;
    }
  }

  List<Map<String, dynamic>> extrairValoresServicos(
      List<Map<String, dynamic>> resultadoFrete) {
    final List<Map<String, dynamic>> lista = [];
    for (var item in resultadoFrete) {
      if (item['name'] == 'PAC' || item['name'] == 'SEDEX') {
        if (item['name'] == 'PAC') {
          lista.add({
            'servico': item['name'],
            'preco': item['price'],
            'prazoEntrega': item['delivery_time'],
            'imagemServico': '../../assets/images/pac_miniatura.png',
          });
        } else if (item['name'] == 'SEDEX') {
          lista.add({
            'servico': item['name'],
            'preco': item['price'],
            'prazoEntrega': item['delivery_time'],
            'imagemServico': '../../assets/images/sedex.png',
          });
        }
      }
    }

    return lista;
  }

  Map<String, dynamic> criarObjetoCalcularFrete(
      String id, String dimensoes, String peso) {
    final partes = dimensoes.split('x');
    return {
      'id': id,
      'width': double.tryParse(partes[0].replaceAll(',', '.')) ?? 0,
      'height': double.tryParse(partes[1].replaceAll(',', '.')) ?? 0,
      'length': double.tryParse(partes[2].replaceAll(',', '.')) ?? 0,
      'weight': double.tryParse(peso.replaceAll(',', '.')) ?? 0,
    };
  }
}
