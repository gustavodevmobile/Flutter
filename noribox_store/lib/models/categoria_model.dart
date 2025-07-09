class Categoria {
  final String id;
  final String nome;
  final String? descricao;

  Categoria({
    required this.id,
    required this.nome,
    this.descricao,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
    );
  }
}