class AbordagemPrincipal {
  final String id;
  final String nome;

  AbordagemPrincipal({required this.id, required this.nome});

  factory AbordagemPrincipal.fromJson(Map<String, dynamic> json) {
    return AbordagemPrincipal(
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