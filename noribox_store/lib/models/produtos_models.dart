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
      descricao: json['descricao'] ?? 'Não informado',
      imagemPrincipal: json['imagemPrincipal'] ?? 'Não informado',
      imagem2: json['imagem2'] ?? 'Não informado',
      imagem3: json['imagem3'] ?? 'Não informado',
      imagem4: json['imagem4'] ?? '',
      material: json['material'] ?? 'Não informado',
      marca: json['marca'] ?? 'Não informado',
      cor: json['cor'] ?? 'Não informado',
      caracteristicas: json['caracteristicas'] ?? 'Não informado',
      dimensoes: json['dimensoes'] ?? 'Não informado',
      ocasiao: json['ocasiao'] ?? 'Não informado',
      sobre: json['sobre'] ?? 'Não informado',
      prazoEntrega: json['prazoEntrega'] ?? 'Não informado',
      frete: json['frete'] ?? 'Não informado',
      freteGratis: json['freteGratis'] ?? false,
      origem: json['origem'] ?? 'Não informado',
      disponivel: json['disponivel'] ?? true,
      categoriaId: json['categoriaId'] ?? 'Não informado',
      categoria: json['categoria'] != null
          ? Categoria.fromJson(json['categoria'])
          : null,
      isEletrico: json['isEletrico'] ?? false,
      consumoEletrico: json['consumoEletrico'] ?? 'Não informado',
      peso: json['peso'] ?? ' Não informado',
      validade: json['validade'] ?? 'Não informado',
      informacoesAdicionais: json['informacoesAdicionais'] ?? 'Não informado',
      sugestoesDeUso: json['sugestoesDeUso'] ?? 'Não informado',
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