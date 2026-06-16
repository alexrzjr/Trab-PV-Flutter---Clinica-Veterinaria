class Cliente {
  final int? idCliente;
  final String nome;
  final String? cpf;
  final String? telefone;
  final String? email;
  final String? endereco;
  final String? observacoes;
  final String? preferenciasContato;

  Cliente({
    this.idCliente,
    required this.nome,
    this.cpf,
    this.telefone,
    this.email,
    this.endereco,
    this.observacoes,
    this.preferenciasContato,
  });

  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      idCliente: map['id_cliente'] as int?,
      nome: map['nome'] as String,
      cpf: map['cpf'] as String?,
      telefone: map['telefone'] as String?,
      email: map['email'] as String?,
      endereco: map['endereco'] as String?,
      observacoes: map['observacoes'] as String?,
      preferenciasContato: map['preferencias_contato'] as String?,
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
      'preferencias_contato': preferenciasContato,
    };
  }
}
