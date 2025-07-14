import 'package:noribox_store/models/categoria_model.dart';

class Produto {
  final String id;
  final String nome;
  final double valorVenda;
  final double valorNoPix;
  final double? valorComJuros;
  final double? valorSemJuros;
  final String descricao;
  final String imagemPrincipal;
  final String? imagem2;
  final String? imagem3;
  final String? imagem4;
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
  final String? categoriaId;
  final Categoria? categoria;
  final bool isEletrico;
  final String? consumoEletrico;
  final String? peso;
  final String? validade;
  final String? informacoesAdicionais;
  final String? sugestoesDeUso;

  Produto({
    required this.id,
    required this.nome,
    required this.valorVenda,
    required this.valorNoPix,
    this.valorComJuros,
    this.valorSemJuros,
    required this.descricao,
    required this.imagemPrincipal,
    this.imagem2,
    this.imagem3,
    this.imagem4,
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
    this.categoriaId,
    this.categoria,
    this.isEletrico = false,
    this.consumoEletrico,
    this.peso,
    this.validade,
    this.informacoesAdicionais,
    this.sugestoesDeUso,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      nome: json['nome'],
      valorVenda: (json['valorVenda'] ?? 0).toDouble(),
      valorNoPix: (json['valorNoPix'] ?? 0).toDouble(),
      valorComJuros: json['valorComJuros'] != null
          ? (json['valorComJuros']).toDouble()
          : null,
      valorSemJuros: json['valorSemJuros'] != null
          ? (json['valorSemJuros']).toDouble()
          : null,
      descricao: json['descricao'] ?? '',
      imagemPrincipal: json['imagemPrincipal'] ?? '',
      imagem2: json['imagem2'] ?? '',
      imagem3: json['imagem3'] ?? '',
      imagem4: json['imagem4'] ?? '',
      material: json['material'] ?? '',
      marca: json['marca'] ?? '',
      cor: json['cor'] ?? '',
      caracteristicas: json['caracteristicas'] ?? '',
      dimensoes: json['dimensoes'] ?? '',
      ocasiao: json['ocasiao'] ?? '',
      sobre: json['sobre'] ?? '',
      prazoEntrega: json['prazoEntrega'] ?? '',
      frete: json['frete'] ?? '',
      freteGratis: json['freteGratis'] ?? false,
      origem: json['origem'] ?? '',
      disponivel: json['disponivel'] ?? true,
      categoriaId: json['categoriaId'] ?? '',
      categoria: json['categoria'] != null
          ? Categoria.fromJson(json['categoria'])
          : null,
      isEletrico: json['isEletrico'] ?? false,
      consumoEletrico: json['consumoEletrico'] ?? '',
      peso: json['peso'] ?? '',
      validade: json['validade'] ?? '',
      informacoesAdicionais: json['informacoesAdicionais'] ?? '',
      sugestoesDeUso: json['sugestoesDeUso'] ?? '',
    );
  }
}

//  valorCompra Float?
//   valorVenda  Float    
//   valorNoPix  Float?   // venda a vista
//   valorComJuros Float? // quando a venda for oferecida parcelamento normal
//   valorSemJuros Float? // quando a venda for oferecida sem juros
//   lucroSobreVenda Float?

// imagemPrincipal String
//   imagem2      String?
//   imagem3      String?
//   imagem4      String?
//   videoProduto String?