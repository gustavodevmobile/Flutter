import 'package:admin_noribox_store/models/categoria.dart';

class Produto {
  final String? id;
  final String nome;
  final double? valorCompra;
  final double valorVenda;
  final double? valorNoPix;
  final double? valorComJuros;
  final double? valorSemJuros;
  final double? lucroSobreVenda;
  final String descricao;
  final String imagemPrincipal;
  final String? imagem2;
  final String? imagem3;
  final String? imagem4;
  final String? videoProduto;
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
  final bool isEletrico;
  final String? consumoEletrico;
  final String? peso;
  final String? validade;
  final String? informacoesAdicionais;
  final String? sugestoesDeUso;
  final String? urlFornecedor;
  final String? idFornecedor;
  final String? parcelamento;
  final String? categoriaId;
  final Categoria? categoria;

  Produto({
    this.id,
    required this.nome,
    this.valorCompra,
    required this.valorVenda,
    this.valorNoPix,
    this.valorComJuros,
    this.valorSemJuros,
    this.lucroSobreVenda,
    required this.descricao,
    required this.imagemPrincipal,
    this.imagem2,
    this.imagem3,
    this.imagem4,
    this.videoProduto,
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
    this.isEletrico = false,
    this.consumoEletrico,
    this.peso,
    this.validade,
    this.informacoesAdicionais,
    this.sugestoesDeUso,
    this.urlFornecedor,
    this.idFornecedor,
    this.parcelamento,
    this.categoriaId,
    this.categoria,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      nome: json['nome'],
      valorCompra: (json['valorCompra'] as num?)?.toDouble(),
      valorVenda: (json['valorVenda'] ?? 0).toDouble(),
      valorNoPix: (json['valorNoPix'] as num?)?.toDouble(),
      valorComJuros: (json['valorComJuros'] as num?)?.toDouble(),
      valorSemJuros: (json['valorSemJuros'] as num?)?.toDouble(),
      lucroSobreVenda: (json['lucroSobreVenda'] as num?)?.toDouble(),
      descricao: json['descricao'] ?? '',
      imagemPrincipal: json['imagemPrincipal'],
      imagem2: json['imagem2'],
      imagem3: json['imagem3'],
      imagem4: json['imagem4'], 
      videoProduto: json['videoProduto'],
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
      isEletrico: json['isEletrico'] ?? false,
      consumoEletrico: json['consumoEletrico'],
      peso: json['peso'],
      validade: json['validade'],
      informacoesAdicionais: json['informacoesAdicionais'],
      sugestoesDeUso: json['sugestoesDeUso'],
      urlFornecedor: json['urlFornecedor'],
      idFornecedor: json['idFornecedor'],
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
      'valorCompra': valorCompra,
      'valorVenda': valorVenda,
      'valorNoPix': valorNoPix,
      'valorComJuros': valorComJuros,
      'valorSemJuros': valorSemJuros,
      'lucroSobreVenda': lucroSobreVenda,
      'descricao': descricao,
      'imagemPrincipal': imagemPrincipal,
      'imagem2': imagem2,
      'imagem3': imagem3,
      'imagem4': imagem4,
      'videoProduto': videoProduto,
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
      'isEletrico': isEletrico,
      'consumoEletrico': consumoEletrico,
      'peso': peso,
      'validade': validade,
      'informacoesAdicionais': informacoesAdicionais,
      'sugestoesDeUso': sugestoesDeUso,
      'urlFornecedor': urlFornecedor,
      'idFornecedor': idFornecedor,
      'parcelamento': parcelamento,
      'categoriaId': categoriaId,
      // 'categoria': categoria?.toMap(), // descomente se precisar enviar categoria detalhada
    };
  }
}
