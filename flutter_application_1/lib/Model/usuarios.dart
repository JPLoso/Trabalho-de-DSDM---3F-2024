import 'dart:typed_data';

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

class livro {
  int? id;
  final String titulo;
  final String autor;
  final String editora;
  final String paginas;
  final String opc;
  final Uint8List? imagem;

  livro(
      {this.id,
      required this.titulo,
      required this.autor,
      required this.editora,
      required this.paginas,
      required this.opc,
      required this.imagem});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'autor': autor,
      'editora': editora,
      'paginas': paginas,
      'opc': opc,
      'imagem': imagem
    };
  }

  @override
  String toString() {
    return 'Livros: {id: $id, titulo:$titulo, autor: $autor, editora: $editora, paginas: $paginas, opc: $opc, imagem: $imagem}';
  }
}
