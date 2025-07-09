class Categoria {
  final String? id;
  final String nome;

  Categoria({
    this.id,
    required this.nome,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'],
      nome: json['nome'],
    );
  }
}
