class usuario {
  int? id;
  final String email;
  final String senha;

  usuario({this.id, required this.email, required this.senha});

  Map<String, Object?> toMap() {
    return {'id': id, 'email': email, 'senha': senha};
  }

  @override
  String toString() {
    return 'Usuarios: {ID: $id, email: $email, senha: $senha}';
  }
}
