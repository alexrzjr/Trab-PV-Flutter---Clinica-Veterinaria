class ItemFatura {
  final int? idItem;
  final int idFatura;
  final String descricao;
  final double valor;

  ItemFatura({
    this.idItem,
    required this.idFatura,
    required this.descricao,
    this.valor = 0,
  });

  factory ItemFatura.fromMap(Map<String, dynamic> map) {
    return ItemFatura(
      idItem: map['id_item'] as int?,
      idFatura: map['id_fatura'] as int,
      descricao: map['descricao'] as String,
      valor: (map['valor'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_fatura': idFatura,
      'descricao': descricao,
      'valor': valor,
    };
  }
}
