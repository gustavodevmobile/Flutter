class EspecialidadePrincipal {
  final String id;
  final String nome;

  EspecialidadePrincipal({required this.id, required this.nome});

  factory EspecialidadePrincipal.fromJson(Map<String, dynamic> json) {
    return EspecialidadePrincipal(
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