class Cliente {
  final int? id_cliente;
  final String nome;
  final String? cpf;
  final String? telefone;
  final String? email;
  final String? endereco;
  final String observacoes;

  Cliente({
    this.id_cliente,
    required this.nome,
    this.cpf,
    this.telefone,
    this.email,
    this.endereco,
    required this.observacoes,
  });

  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      id_cliente: map['id_cliente'],
      nome: map['nome'],
      cpf: map['cpf'],
      telefone: map['telefone'],
      email: map['email'],
      endereco: map['endereco'],
      observacoes: map['observacoes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'cpf': cpf,
      'telefone': telefone,
      'email': email,
      'endereco': endereco,
      'observacoes': observacoes,
    };
  }
}
