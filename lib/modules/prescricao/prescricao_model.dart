class Prescricao {
  final int? id_prescricao;
  final int? id_prontuario;
  final int? id_medicamento;
  final String? dosagem;
  final String? frequencia;
  final String? duracao;

  Prescricao({
    this.id_prescricao,
    this.id_prontuario,
    this.id_medicamento,
    this.dosagem,
    this.frequencia,
    this.duracao,
  });

  factory Prescricao.fromMap(Map<String, dynamic> map) {
    return Prescricao(
      id_prescricao: map['id_prescricao'],
      id_prontuario: map['id_prontuario'],
      id_medicamento: map['id_medicamento'],
      dosagem: map['dosagem'],
      frequencia: map['frequencia'],
      duracao: map['duracao'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_prontuario': id_prontuario,
      'id_medicamento': id_medicamento,
      'dosagem': dosagem,
      'frequencia': frequencia,
      'duracao': duracao,
    };
  }
}
