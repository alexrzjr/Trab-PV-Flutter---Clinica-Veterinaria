class Pagamento {
  final int? idPagamento;
  final int idFatura;
  final String dataPagamento;
  final double valor;
  final String formaPagamento;

  Pagamento({
    this.idPagamento,
    required this.idFatura,
    required this.dataPagamento,
    required this.valor,
    required this.formaPagamento,
  });

  factory Pagamento.fromMap(Map<String, dynamic> map) {
    return Pagamento(
      idPagamento: map['id_pagamento'] as int?,
      idFatura: map['id_fatura'] as int,
      dataPagamento: map['data_pagamento'] as String,
      valor: (map['valor'] as num?)?.toDouble() ?? 0,
      formaPagamento: map['forma_pagamento'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_fatura': idFatura,
      'data_pagamento': dataPagamento,
      'valor': valor,
      'forma_pagamento': formaPagamento,
    };
  }
}
