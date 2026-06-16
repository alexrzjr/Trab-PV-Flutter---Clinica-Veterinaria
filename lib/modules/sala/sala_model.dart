class Sala {
  final int? idSala;
  final String nome;
  final int capacidade;
  final bool disponivel;

  Sala({
    this.idSala,
    required this.nome,
    this.capacidade = 1,
    this.disponivel = true,
  });

  factory Sala.fromMap(Map<String, dynamic> map) {
    return Sala(
      idSala: map['id_sala'] as int?,
      nome: map['nome'] as String,
      capacidade: (map['capacidade'] as int?) ?? 1,
      disponivel: (map['disponivel'] as int? ?? 1) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'capacidade': capacidade,
      'disponivel': disponivel ? 1 : 0,
    };
  }
}
