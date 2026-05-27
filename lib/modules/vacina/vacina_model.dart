class Vacina {
  final int? id_vacina;
  final String? nome;
  final String? intervalo_reforco;

  Vacina({
    this.id_vacina,
    this.nome,
    this.intervalo_reforco,
  });

  factory Vacina.fromMap(Map<String, dynamic> map) {
    return Vacina(
      id_vacina: map['id_vacina'],
      nome: map['nome'],
      intervalo_reforco: map['intervalo_reforco'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'intervalo_reforco': intervalo_reforco,
    };
  }
}
