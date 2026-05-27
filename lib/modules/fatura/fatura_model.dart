class Fatura {
  final int? id_fatura;
  final int? id_cliente;
  final String? data_fatura;
  final String? valor_total;
  final String? status;

  Fatura({
    this.id_fatura,
    this.id_cliente,
    this.data_fatura,
    this.valor_total,
    this.status,
  });

  factory Fatura.fromMap(Map<String, dynamic> map) {
    return Fatura(
      id_fatura: map['id_fatura'],
      id_cliente: map['id_cliente'],
      data_fatura: map['data_fatura'],
      valor_total: map['valor_total'],
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_cliente': id_cliente,
      'data_fatura': data_fatura,
      'valor_total': valor_total,
      'status': status,
    };
  }
}
