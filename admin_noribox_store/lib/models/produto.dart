class Produto {
  final String? id;
  final String nome;
  final String descricao;
  final double valor;
  final String imagem;

  Produto({
    this.id,
    required this.nome,
    required this.descricao,
    required this.valor,
    required this.imagem,
  });

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map['_id'] ?? map['id'], // Verifica se _id ou id está presente
      nome: map['nome'] ?? '',
      descricao: map['descricao'] ?? '',
      valor: map['valor'] is int
          ? (map['valor'] as int).toDouble()
          : (map['valor'] ?? 0.0),
      imagem: map['imagem'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'nome': nome,
      'descricao': descricao,
      'valor': valor,
      'imagem': imagem,
    };
  }
}
