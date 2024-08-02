import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/usuarios.dart';
import 'package:flutter_application_1/database/dao/usuariosdao.dart';
import 'package:flutter_application_1/database/db.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
  }

  databaseFactory = databaseFactoryFfi;
  runApp(
    MaterialApp(
      home: login(),
    ),
  );
}

// Página inicial onde os usúarios vão colocar seus dados e entrar.
class login extends StatefulWidget {
  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final TextEditingController EmailController = TextEditingController();
  final TextEditingController SenhaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Biblioteca Pessoal"),
      ),
      body: ListView(children: <Widget>[
        Container(
          padding: const EdgeInsets.all(19.0),
          child: Column(
            children: [
              TextField(
                  controller: EmailController,
                  decoration: InputDecoration(
                      labelText: "Email",
                      icon: const Icon(Icons.email_outlined))),
              TextField(
                controller: SenhaController,
                decoration: InputDecoration(
                  labelText: "Senha",
                  icon: Icon(Icons.enhanced_encryption_outlined),
                ),
              )
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (EmailController.text != null && SenhaController.text != null) {
              Future<bool> verificacao = verificaUsuarioESenha(
                  EmailController.text, SenhaController.text);
              // if(){}
              verificacao.then((valor) {
                if (valor == true) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => homePage()));
                } else {
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Usuario ou senha incorretos'),
                        content: const SingleChildScrollView(child: Text("")),
                      );
                    },
                  );
                }
              });
            }
            child:
            const Text('Login');
          },
          child: null,
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => cadastroUsuario()));
          },
          child: const Text('Não possui conta? Cadastre-se'),
        )
      ]), //
    );
  }
}

class Usuario extends StatelessWidget {
  late String email;
  late String senha;

  Usuario({
    required this.email,
    required this.senha,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridTile(
        child: ListTile(
      title: Text(this.email),
      subtitle: Text(this.senha),
    ));
  }
}

class cadastroUsuario extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController cSenhaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("biblioteca Pessoal"),
      ),
      body: ListView(children: <Widget>[
        Text(
          "Cadastro de usuario",
          style: TextStyle(fontSize: 80, fontFamily: 'Raleway'),
        ),
        Container(
          padding: const EdgeInsets.all(19.0),
          child: Column(
            children: [
              TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      labelText: "Email",
                      icon: const Icon(Icons.email_outlined))),
              TextField(
                obscureText: true,
                controller: senhaController,
                decoration: InputDecoration(
                  labelText: "Senha",
                  icon: Icon(Icons.enhanced_encryption_outlined),
                ),
              ),
              TextField(
                obscureText: true,
                controller: cSenhaController,
                decoration: InputDecoration(
                  labelText: "Confirmar senha",
                  icon: Icon(Icons.enhanced_encryption_outlined),
                ),
              )
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(
                context,
                Usuario(
                  email: emailController.text,
                  senha: senhaController.text,
                ));
            usuario c = usuario(
              email: emailController.text,
              senha: senhaController.text,
            );
            insertUsuario(c);
          },
          child: const Text('Cadatrar'),
        )
      ]), //
    );
  }
}

class homePage extends StatefulWidget {
  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ElevatedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => cadastroUsuario()));
          },
          child: const Icon(Icons.add),
        ));
  }
}

class cadastroLivro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Biblioteca Pessoal"),
        ),
        body: ListView(children: <Widget>[
          Text(
            "Cadastro de usuario",
            style: TextStyle(fontSize: 80, fontFamily: 'Raleway'),
          ),
          Container(
            padding: const EdgeInsets.all(19.0),
            child: Column(
              children: [
                TextField(
                    decoration: InputDecoration(
                        labelText: "Titulo",
                        icon: const Icon(Icons.email_outlined))),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Autor",
                    icon: Icon(Icons.enhanced_encryption_outlined),
                  ),
                ),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Editora",
                    icon: Icon(Icons.enhanced_encryption_outlined),
                  ),
                ),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Editora",
                    icon: Icon(Icons.enhanced_encryption_outlined),
                  ),
                )
              ],
            ),
          ),
        ]));
  }
}
