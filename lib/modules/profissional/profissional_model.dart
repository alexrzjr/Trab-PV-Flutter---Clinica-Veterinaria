class Profissional {
  final int? idProfissional;
  final String nome;
  final String? especialidade;
  final String? crmv;
  final String? telefone;
  final String? email;

  Profissional({
    this.idProfissional,
    required this.nome,
    this.especialidade,
    this.crmv,
    this.telefone,
    this.email,
  });

  factory Profissional.fromMap(Map<String, dynamic> map) {
    return Profissional(
      idProfissional: map['id_profissional'] as int?,
      nome: map['nome'] as String,
      especialidade: map['especialidade'] as String?,
      crmv: map['crmv'] as String?,
      telefone: map['telefone'] as String?,
      email: map['email'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'especialidade': especialidade,
      'crmv': crmv,
      'telefone': telefone,
      'email': email,
    };
  }
}
