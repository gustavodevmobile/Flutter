class TemasClinicos {
  final String id;
  final String nome;

  TemasClinicos({required this.id, required this.nome});

  factory TemasClinicos.fromJson(Map<String, dynamic> json) {
    return TemasClinicos(
      id: json['id'],
      nome: json['nome'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
    };
  }
}