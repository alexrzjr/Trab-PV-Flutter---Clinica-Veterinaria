class Prontuario {
  final int? id_prontuario;
  final int? id_animal;
  final int? id_consulta;
  final String? data_registro;
  final String? diagnostico;
  final String? observacoes;

  Prontuario({
    this.id_prontuario,
    this.id_animal,
    this.id_consulta,
    this.data_registro,
    this.diagnostico,
    this.observacoes,
  });

  factory Prontuario.fromMap(Map<String, dynamic> map) {
    return Prontuario(
      id_prontuario: map['id_prontuario'],
      id_animal: map['id_animal'],
      id_consulta: map['id_consulta'],
      data_registro: map['data_registro'],
      diagnostico: map['diagnostico'],
      observacoes: map['observacoes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_animal': id_animal,
      'id_consulta': id_consulta,
      'data_registro': data_registro,
      'diagnostico': diagnostico,
      'observacoes': observacoes,
    };
  }
}
