class Profissional {
  final int? id_profissional;
  final String? nome;
  final String? especialidade;
  final String? crmv;

  Profissional({
    this.id_profissional,
    this.nome,
    this.especialidade,
    this.crmv,
  });

  factory Profissional.fromMap(Map<String, dynamic> map) {
    return Profissional(
      id_profissional: map['id_profissional'],
      nome: map['nome'],
      especialidade: map['especialidade'],
      crmv: map['crmv'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'nome': nome, 'especialidade': especialidade, 'crmv': crmv};
  }
}
