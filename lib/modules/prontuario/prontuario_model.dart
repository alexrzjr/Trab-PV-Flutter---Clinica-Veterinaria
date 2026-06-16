class Prontuario {
  final int? idProntuario;
  final int idAnimal;
  final int? idConsulta;
  final String dataRegistro;
  final String? diagnostico;
  final String? observacoes;

  Prontuario({
    this.idProntuario,
    required this.idAnimal,
    this.idConsulta,
    required this.dataRegistro,
    this.diagnostico,
    this.observacoes,
  });

  factory Prontuario.fromMap(Map<String, dynamic> map) {
    return Prontuario(
      idProntuario: map['id_prontuario'] as int?,
      idAnimal: map['id_animal'] as int,
      idConsulta: map['id_consulta'] as int?,
      dataRegistro: map['data_registro'] as String,
      diagnostico: map['diagnostico'] as String?,
      observacoes: map['observacoes'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_animal': idAnimal,
      'id_consulta': idConsulta,
      'data_registro': dataRegistro,
      'diagnostico': diagnostico,
      'observacoes': observacoes,
    };
  }
}
