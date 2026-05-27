class Medicamento {
  final int? id_medicamento;
  final String? nome;
  final String? lote;
  final String? validade;
  final String? quantidade_estoque;
  final String? tipo;

  Medicamento({
    this.id_medicamento,
    this.nome,
    this.lote,
    this.validade,
    this.quantidade_estoque,
    this.tipo,
  });

  factory Medicamento.fromMap(Map<String, dynamic> map) {
    return Medicamento(
      id_medicamento: map['id_medicamento'],
      nome: map['nome'],
      lote: map['lote'],
      validade: map['validade'],
      quantidade_estoque: map['quantidade_estoque'],
      tipo: map['tipo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'lote': lote,
      'validade': validade,
      'quantidade_estoque': quantidade_estoque,
      'tipo': tipo,
    };
  }
}
