class Item_fatura {
  final int? id_item;
  final int? id_fatura;
  final String descricao;
  final String? valor;

  Item_fatura({
    this.id_item,
    this.id_fatura,
    required this.descricao,
    this.valor,
  });

  factory Item_fatura.fromMap(Map<String, dynamic> map) {
    return Item_fatura(
      id_item: map['id_item'],
      id_fatura: map['id_fatura'],
      descricao: map['descricao'],
      valor: map['valor'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_fatura': id_fatura,
      'descricao': descricao,
      'valor': valor,
    };
  }
}
