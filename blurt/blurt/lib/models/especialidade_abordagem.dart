class Especialidade {
  final String id;
  final String nome;

  Especialidade({required this.id, required this.nome});

  factory Especialidade.fromJson(Map<String, dynamic> json) {
    return Especialidade(
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

class Abordagem {
  final String id;
  final String nome;

  Abordagem({required this.id, required this.nome});

  factory Abordagem.fromJson(Map<String, dynamic> json) {
    return Abordagem(
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
