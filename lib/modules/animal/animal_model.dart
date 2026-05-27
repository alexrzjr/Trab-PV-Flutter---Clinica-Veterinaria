class Animal {
  final int? id_animal;
  final int id_cliente;
  final String nome;
  final String especie;
  final String? raca;
  final String? sexo;
  final String? data_nascimento;

  Animal({
    this.id_animal,
    required this.id_cliente,
    required this.nome,
    required this.especie,
    this.raca,
    this.sexo,
    this.data_nascimento,
  });

  factory Animal.fromMap(Map<String, dynamic> map) {
    return Animal(
      id_animal: map['id_animal'],
      id_cliente: map['id_cliente'],
      nome: map['nome'],
      especie: map['especie'],
      raca: map['raca'],
      sexo: map['sexo'],
      data_nascimento: map['data_nascimento'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_cliente': id_cliente,
      'nome': nome,
      'especie': especie,
      'raca': raca,
      'sexo': sexo,
      'data_nascimento': data_nascimento,
    };
  }
}
