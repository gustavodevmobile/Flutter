import 'package:admin_noribox_store/models/categoria.dart';

class Produto {
  final String? id;
  final String nome;
  final double valor;
  final String descricao;
  final String imagem;
  final String? material;
  final String? marca;
  final String? cor;
  final String? caracteristicas;
  final String? dimensoes;
  final String? ocasiao;
  final String? sobre;
  final String? prazoEntrega;
  final String? frete;
  final bool freteGratis;
  final String? origem;
  final bool disponivel;
  final String? parcelamento;
  final String? categoriaId;

  // Você pode criar um model Categoria se quiser detalhar mais
  final Categoria? categoria;

  Produto({
    this.id,
    required this.nome,
    required this.valor,
    required this.descricao,
    required this.imagem,
    this.material,
    this.marca,
    this.cor,
    this.caracteristicas,
    this.dimensoes,
    this.ocasiao,
    this.sobre,
    this.prazoEntrega,
    this.frete,
    this.freteGratis = false,
    this.origem,
    this.disponivel = true,
    this.parcelamento,
    this.categoriaId,
    this.categoria,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      nome: json['nome'],
      valor: (json['valor'] ?? 0).toDouble(),
      descricao: json['descricao'] ?? '',
      imagem: json['imagem'] ?? '',
      material: json['material'],
      marca: json['marca'],
      cor: json['cor'],
      caracteristicas: json['caracteristicas'],
      dimensoes: json['dimensoes'],
      ocasiao: json['ocasiao'],
      sobre: json['sobre'],
      prazoEntrega: json['prazoEntrega'],
      frete: json['frete'],
      freteGratis: json['freteGratis'] ?? false,
      origem: json['origem'],
      disponivel: json['disponivel'] ?? true,
      parcelamento: json['parcelamento'],
      categoriaId: json['categoriaId'],
      categoria: json['categoria'] != null
          ? Categoria.fromJson(json['categoria'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'valor': valor,
      'descricao': descricao,
      'imagem': imagem,
      'material': material,
      'marca': marca,
      'cor': cor,
      'caracteristicas': caracteristicas,
      'dimensoes': dimensoes,
      'ocasiao': ocasiao,
      'sobre': sobre,
      'prazoEntrega': prazoEntrega,
      'frete': frete,
      'freteGratis': freteGratis,
      'origem': origem,
      'disponivel': disponivel,
      'parcelamento': parcelamento,
      'categoriaId': categoriaId,
      // Se quiser enviar a categoria detalhada, descomente a linha abaixo:
      // 'categoria': categoria?.toMap(),
    };
  }
}
