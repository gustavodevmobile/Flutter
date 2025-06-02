// Model para Profissional
class ProfissionalModel {
  final String id;
  final String nome;
  // ... outros campos
  ProfissionalModel({required this.id, required this.nome});

  factory ProfissionalModel.fromJson(Map<String, dynamic> json) =>
      ProfissionalModel(id: json['id'], nome: json['nome']);

  Map<String, dynamic> toJson() => {'id': id, 'nome': nome};
}
