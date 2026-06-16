class AplicacaoVacina {
  final int? idAplicacao;
  final int idProntuario;
  final int idVacina;
  final String dataAplicacao;
  final String? dataReforco;

  AplicacaoVacina({
    this.idAplicacao,
    required this.idProntuario,
    required this.idVacina,
    required this.dataAplicacao,
    this.dataReforco,
  });

  factory AplicacaoVacina.fromMap(Map<String, dynamic> map) {
    return AplicacaoVacina(
      idAplicacao: map['id_aplicacao'] as int?,
      idProntuario: map['id_prontuario'] as int,
      idVacina: map['id_vacina'] as int,
      dataAplicacao: map['data_aplicacao'] as String,
      dataReforco: map['data_reforco'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_prontuario': idProntuario,
      'id_vacina': idVacina,
      'data_aplicacao': dataAplicacao,
      'data_reforco': dataReforco,
    };
  }
}
