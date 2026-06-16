class Vacina {
  final int? idVacina;
  final String nome;
  final int intervaloReforco;

  Vacina({
    this.idVacina,
    required this.nome,
    this.intervaloReforco = 365,
  });

  factory Vacina.fromMap(Map<String, dynamic> map) {
    return Vacina(
      idVacina: map['id_vacina'] as int?,
      nome: map['nome'] as String,
      intervaloReforco: (map['intervalo_reforco'] as int?) ?? 365,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'intervalo_reforco': intervaloReforco,
    };
  }
}
