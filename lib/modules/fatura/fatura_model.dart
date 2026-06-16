class Fatura {
  final int? idFatura;
  final int idCliente;
  final String dataFatura;
  final double valorTotal;
  final String status;
  final String? observacoes;

  Fatura({
    this.idFatura,
    required this.idCliente,
    required this.dataFatura,
    this.valorTotal = 0,
    this.status = 'pendente',
    this.observacoes,
  });

  factory Fatura.fromMap(Map<String, dynamic> map) {
    return Fatura(
      idFatura: map['id_fatura'] as int?,
      idCliente: map['id_cliente'] as int,
      dataFatura: map['data_fatura'] as String,
      valorTotal: (map['valor_total'] as num?)?.toDouble() ?? 0,
      status: map['status'] as String? ?? 'pendente',
      observacoes: map['observacoes'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_cliente': idCliente,
      'data_fatura': dataFatura,
      'valor_total': valorTotal,
      'status': status,
      'observacoes': observacoes,
    };
  }
}
