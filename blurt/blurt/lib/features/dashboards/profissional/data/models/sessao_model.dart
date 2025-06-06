// Model para Sessao
class SessaoModel {
  final String id;
  final String profissional;
  // ... outros campos
  SessaoModel({required this.id, required this.profissional});

  factory SessaoModel.fromJson(Map<String, dynamic> json) =>
      SessaoModel(id: json['id'], profissional: json['profissional']);

  Map<String, dynamic> toJson() => {'id': id, 'profissional': profissional};
}
