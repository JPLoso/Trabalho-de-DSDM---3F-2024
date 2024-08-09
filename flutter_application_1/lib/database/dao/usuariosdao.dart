import 'package:flutter_application_1/Model/usuarios.dart';
import 'package:sqflite/sqflite.dart';
import '../db.dart';

Future<int> insertUsuario(usuario Usuario) async {
  Database db = await getDatabase();
  return db.insert('usuarios', Usuario.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
}

Future<List<Map<String, dynamic>>> findall() async {
  Database db = await getDatabase();
  List<Map<String, dynamic>> dados = await db.query('usuarios');

  dados.forEach((usuario) {
    print(usuario);
  });
  return dados;
}

Future<bool> verificaUsuarioESenha(String email, String senha) async {
  Database db = await getDatabase();
  List<Map<String, dynamic>> dados = await db.query('usuarios',
      where: 'email = ? and senha = ?', whereArgs: [email, senha]);

  if (dados.isNotEmpty) {
    return true;
  } else {
    return false;
  }
}
