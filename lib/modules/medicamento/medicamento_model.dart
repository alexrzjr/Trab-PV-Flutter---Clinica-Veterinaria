class Medicamento {
  final int? idMedicamento;
  final String nome;
  final String? lote;
  final String? validade;
  final int quantidadeEstoque;
  final int estoqueMinimo;
  final String? tipo;
  final String? alertaInteracao;

  Medicamento({
    this.idMedicamento,
    required this.nome,
    this.lote,
    this.validade,
    this.quantidadeEstoque = 0,
    this.estoqueMinimo = 5,
    this.tipo,
    this.alertaInteracao,
  });

  factory Medicamento.fromMap(Map<String, dynamic> map) {
    return Medicamento(
      idMedicamento: map['id_medicamento'] as int?,
      nome: map['nome'] as String,
      lote: map['lote'] as String?,
      validade: map['validade'] as String?,
      quantidadeEstoque: (map['quantidade_estoque'] as int?) ?? 0,
      estoqueMinimo: (map['estoque_minimo'] as int?) ?? 5,
      tipo: map['tipo'] as String?,
      alertaInteracao: map['alerta_interacao'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'lote': lote,
      'validade': validade,
      'quantidade_estoque': quantidadeEstoque,
      'estoque_minimo': estoqueMinimo,
      'tipo': tipo,
      'alerta_interacao': alertaInteracao,
    };
  }

  bool get estoqueBaixo => quantidadeEstoque <= estoqueMinimo;
}
