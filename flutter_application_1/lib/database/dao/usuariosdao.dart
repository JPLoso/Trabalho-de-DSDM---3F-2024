import 'dart:typed_data';

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

class DatabaseHelper {
  // Método para inserir uma imagem no banco de dados
  static Future<void> insertImage(Uint8List imageBytes) async {
    // Obtém a instância do banco de dados
    final db = await getDatabase();

    // Insere os dados da imagem na tabela 'images'
    await db.insert('images', {'image': imageBytes});
  }

  static Future<Uint8List?> getImage() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('livros');
    if (maps.isNotEmpty) {
      return maps.first['imagem'] as Uint8List?;
    }
    return null;
  }
}
