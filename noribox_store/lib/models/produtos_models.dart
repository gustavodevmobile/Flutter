class Produto {
  final String id;
  final String nome;
  final String descricao;
  final double preco;
  final String imagem;
  final String? avaliacao;

  Produto({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.imagem,
    this.avaliacao,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'] ?? 'Sem descrição',
      preco: (json['valor'] ?? 0).toDouble(),
      imagem: json['imagem'],
      avaliacao: json['avaliacao']?.toString() ?? '4', // Mock value if not provided
    );
  }
}
