class Animal {
  final int? idAnimal;
  final int idCliente;
  final String nome;
  final String especie;
  final String? raca;
  final String? sexo;
  final String? dataNascimento;
  final double? peso;
  final String? historicoMedico;
  final String? vacinacao;
  final String? preferencias;

  Animal({
    this.idAnimal,
    required this.idCliente,
    required this.nome,
    required this.especie,
    this.raca,
    this.sexo,
    this.dataNascimento,
    this.peso,
    this.historicoMedico,
    this.vacinacao,
    this.preferencias,
  });

  factory Animal.fromMap(Map<String, dynamic> map) {
    return Animal(
      idAnimal: map['id_animal'] as int?,
      idCliente: map['id_cliente'] as int,
      nome: map['nome'] as String,
      especie: map['especie'] as String,
      raca: map['raca'] as String?,
      sexo: map['sexo'] as String?,
      dataNascimento: map['data_nascimento'] as String?,
      peso: (map['peso'] as num?)?.toDouble(),
      historicoMedico: map['historico_medico'] as String?,
      vacinacao: map['vacinacao'] as String?,
      preferencias: map['preferencias'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_cliente': idCliente,
      'nome': nome,
      'especie': especie,
      'raca': raca,
      'sexo': sexo,
      'data_nascimento': dataNascimento,
      'peso': peso,
      'historico_medico': historicoMedico,
      'vacinacao': vacinacao,
      'preferencias': preferencias,
    };
  }
}
