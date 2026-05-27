class Aplicacao_vacina {
  final int? id_aplicacao;
  final int id_prontuario;
  final int id_vacina;
  final String? data_aplicacao;
  final String? data_reforco;

  Aplicacao_vacina({
    this.id_aplicacao,
    required this.id_prontuario,
    required this.id_vacina,
    this.data_aplicacao,
    this.data_reforco,
  });

  factory Aplicacao_vacina.fromMap(Map<String, dynamic> map) {
    return Aplicacao_vacina(
      id_aplicacao: map['id_aplicacao'],
      id_prontuario: map['id_prontuario'],
      id_vacina: map['id_vacina'],
      data_aplicacao: map['data_aplicacao'],
      data_reforco: map['data_reforco'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_prontuario': id_prontuario,
      'id_vacina': id_vacina,
      'data_aplicacao': data_aplicacao,
      'data_reforco': data_reforco,
    };
  }
}
