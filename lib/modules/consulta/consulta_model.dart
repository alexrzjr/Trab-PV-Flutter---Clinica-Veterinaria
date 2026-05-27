class Consulta {
  final int? id_consulta;
  final int? id_animal;
  final int? id_profissional;
  final String? data_hora;
  final String? status;
  final String? tipo;

  Consulta({
    this.id_consulta,
    this.id_animal,
    this.id_profissional,
    this.data_hora,
    this.status,
    this.tipo,
  });

  factory Consulta.fromMap(Map<String, dynamic> map) {
    return Consulta(
      id_consulta: map['id_consulta'],
      id_animal: map['id_animal'],
      id_profissional: map['id_profissional'],
      data_hora: map['data_hora'],
      status: map['status'],
      tipo: map['tipo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_animal': id_animal,
      'id_profissional': id_profissional,
      'data_hora': data_hora,
      'status': status,
      'tipo': tipo,
    };
  }
}
