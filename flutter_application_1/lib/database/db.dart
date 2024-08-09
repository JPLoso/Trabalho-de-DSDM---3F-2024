import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async {
  String caminhoBanco = join(await getDatabasesPath(), 'usuarios3.db');

  return openDatabase(
    caminhoBanco,
    version: 1,
    onCreate: (db, version) {
      db.execute(
          'create table usuarios(id integer primary key AUTOINCREMENT, email text, Senha text)');
      db.execute(
          'create table livros(id integer primary key AUTOINCREMENT, titulo text, autor text, editora text, paginas text, opc text, imagem text)');
    },
  );
}
