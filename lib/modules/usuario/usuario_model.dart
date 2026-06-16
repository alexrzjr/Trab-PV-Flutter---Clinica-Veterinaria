class Usuario {
  final int? idUsuario;
  final String nome;
  final String email;
  final String senha;
  final String perfil;

  Usuario({
    this.idUsuario,
    required this.nome,
    required this.email,
    required this.senha,
    this.perfil = 'admin',
  });

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      idUsuario: map['id_usuario'] as int?,
      nome: map['nome'] as String,
      email: map['email'] as String,
      senha: map['senha'] as String,
      perfil: map['perfil'] as String? ?? 'admin',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'email': email,
      'senha': senha,
      'perfil': perfil,
    };
  }
}
