class Consulta {
  final int? idConsulta;
  final int idAnimal;
  final int idProfissional;
  final int? idSala;
  final String dataHora;
  final String status;
  final String? tipo;
  final String? observacoes;
  final bool lembreteEnviado;

  Consulta({
    this.idConsulta,
    required this.idAnimal,
    required this.idProfissional,
    this.idSala,
    required this.dataHora,
    required this.status,
    this.tipo,
    this.observacoes,
    this.lembreteEnviado = false,
  });

  factory Consulta.fromMap(Map<String, dynamic> map) {
    return Consulta(
      idConsulta: map['id_consulta'] as int?,
      idAnimal: map['id_animal'] as int,
      idProfissional: map['id_profissional'] as int,
      idSala: map['id_sala'] as int?,
      dataHora: map['data_hora'] as String,
      status: map['status'] as String,
      tipo: map['tipo'] as String?,
      observacoes: map['observacoes'] as String?,
      lembreteEnviado: (map['lembrete_enviado'] as int? ?? 0) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_animal': idAnimal,
      'id_profissional': idProfissional,
      'id_sala': idSala,
      'data_hora': dataHora,
      'status': status,
      'tipo': tipo,
      'observacoes': observacoes,
      'lembrete_enviado': lembreteEnviado ? 1 : 0,
    };
  }
}
