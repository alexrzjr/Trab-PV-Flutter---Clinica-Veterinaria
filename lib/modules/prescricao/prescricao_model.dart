class Prescricao {
  final int? idPrescricao;
  final int idProntuario;
  final int idMedicamento;
  final String? dosagem;
  final String? frequencia;
  final String? duracao;

  Prescricao({
    this.idPrescricao,
    required this.idProntuario,
    required this.idMedicamento,
    this.dosagem,
    this.frequencia,
    this.duracao,
  });

  factory Prescricao.fromMap(Map<String, dynamic> map) {
    return Prescricao(
      idPrescricao: map['id_prescricao'] as int?,
      idProntuario: map['id_prontuario'] as int,
      idMedicamento: map['id_medicamento'] as int,
      dosagem: map['dosagem'] as String?,
      frequencia: map['frequencia'] as String?,
      duracao: map['duracao'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_prontuario': idProntuario,
      'id_medicamento': idMedicamento,
      'dosagem': dosagem,
      'frequencia': frequencia,
      'duracao': duracao,
    };
  }
}
