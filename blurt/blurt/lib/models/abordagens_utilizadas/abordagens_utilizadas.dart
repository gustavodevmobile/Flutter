class AbordagensUtilizadas {
  final String id;
  final String nome;

  AbordagensUtilizadas({required this.id, required this.nome});

  factory AbordagensUtilizadas.fromJson(Map<String, dynamic> json) {
    return AbordagensUtilizadas(
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