import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/usuarios.dart';
import 'package:flutter_application_1/database/dao/usuariosdao.dart';
import 'package:flutter_application_1/database/db.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:typed_data';

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
                          actions: <Widget>[
                            TextButton(
                              style: TextButton.styleFrom(
                                textStyle:
                                    Theme.of(context).textTheme.labelLarge,
                              ),
                              child: const Text('ok'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ]);
                    },
                  );
                }
              });
            }
          },
          child: const Text('Login'),
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

class Usuario extends StatefulWidget {
  late String email;
  late String senha;

  Usuario({
    required this.email,
    required this.senha,
    Key? key,
  }) : super(key: key);

  @override
  State<Usuario> createState() => _UsuarioState();
}

class _UsuarioState extends State<Usuario> {
  @override
  Widget build(BuildContext context) {
    return GridTile(
        child: ListTile(
      title: Text(this.widget.email),
      subtitle: Text(this.widget.senha),
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
            if (senhaController.text == cSenhaController.text) {
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
            } else {
              showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: const Text('Senha diferente no confirmar senha'),
                      content: const SingleChildScrollView(child: Text("")),
                      actions: <Widget>[
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: Theme.of(context).textTheme.labelLarge,
                          ),
                          child: const Text('ok'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ]);
                },
              );
            }
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
  Uint8List? imagem;
  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    Uint8List? imageBytes = await DatabaseHelper.getImage();
    setState(() {
      imagem = imageBytes;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView(children: [
          Column(
            children: [
              Row(children: [
                Title(
                    color: Colors.black, child: Text("Minhas histórias/Lendo")),
                Container(
                  child: ElevatedButton(
                    onPressed: () {
                      // Ação ao pressionar o botão
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Botão pressionado!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.all(16),
                    ),
                    child: imagem != null
                        ? Image.memory(
                            imagem!,
                            height: 50,
                            width: 50,
                          )
                        : Icon(Icons.image,
                            size:
                                50), // Exibe um ícone padrão se a imagem não estiver disponível
                  ),
                )
              ]),
              Row(
                children: [
                  Title(color: Colors.black, child: Text("Pretendo ler")),
                  Container(
                    height: 300,
                  ),
                ],
              ),
              Row(
                children: [
                  Title(
                      color: Colors.black,
                      child: Text("Histórias finalizadas")),
                  Container(
                    height: 300,
                  ),
                ],
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => cadastroLivro()));
            },
            child: const Icon(Icons.add),
          ),
        ]));
  }
}

List<String> options = ['Sim', 'Pretendo', 'Finalizado'];

class cadastroLivro extends StatefulWidget {
  @override
  State<cadastroLivro> createState() => _cadastroLivroState();
}

class _cadastroLivroState extends State<cadastroLivro> {
  TextEditingController cTitulo = TextEditingController();
  TextEditingController cAutor = TextEditingController();
  TextEditingController cEditora = TextEditingController();
  TextEditingController cPaginas = TextEditingController();

  String currentOption = options[0];
  List<XFile>? _mediaFileList;
  late Uint8List? imagem;

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Biblioteca Pessoal"),
      ),
      body: ListView(children: <Widget>[
        Text(
          "Cadastro de livros",
          style: TextStyle(fontSize: 80, fontFamily: 'Raleway'),
        ),
        Container(
          padding: const EdgeInsets.all(19.0),
          child: Column(
            children: [
              TextField(
                  controller: cTitulo,
                  decoration: InputDecoration(
                      labelText: "Titulo",
                      icon: const Icon(Icons.email_outlined))),
              TextField(
                controller: cAutor,
                decoration: InputDecoration(
                  labelText: "Autor",
                  icon: Icon(Icons.enhanced_encryption_outlined),
                ),
              ),
              TextField(
                controller: cEditora,
                decoration: InputDecoration(
                  labelText: "Editora",
                  icon: Icon(Icons.enhanced_encryption_outlined),
                ),
              ),
              TextField(
                controller: cPaginas,
                decoration: InputDecoration(
                  labelText: "Quantidade de páginas",
                  icon: Icon(Icons.enhanced_encryption_outlined),
                ),
              ),
              Row(
                children: [
                  Padding(padding: EdgeInsets.fromLTRB(0, 80, 0, 0)),
                  Text("Está Lendo?",
                      style: TextStyle(fontSize: 25, fontFamily: 'Raleway')),
                ],
              ),
              ListTile(
                title: Text('Sim'),
                leading: Radio(
                  value: options[0],
                  groupValue: currentOption,
                  onChanged: (value) {
                    setState(() {
                      currentOption = value.toString();
                    });
                  },
                ),
              ),
              ListTile(
                title: Text('Pretendo'),
                leading: Radio(
                  value: options[1],
                  groupValue: currentOption,
                  onChanged: (value) {
                    setState(() {
                      currentOption = value.toString();
                    });
                  },
                ),
              ),
              ListTile(
                title: Text('Finalizado'),
                leading: Radio(
                  value: options[2],
                  groupValue: currentOption,
                  onChanged: (value) {
                    setState(() {
                      currentOption = value.toString();
                    });
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final XFile? imagem =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (imagem != null) {
                    setState(() {
                      _mediaFileList = [imagem];
                    });
                  }
                },
                child: Text('Selecionar Imagem'),
              ),
              if (_mediaFileList != null && _mediaFileList!.isNotEmpty)
                Image.file(File(_mediaFileList![0].path)),
            ],
          ),
        ),
        ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              Uint8List? imageBytes = imagem;
              livro c = livro(
                  titulo: cTitulo.text,
                  autor: cAutor.text,
                  editora: cEditora.text,
                  paginas: cPaginas.text,
                  opc: currentOption,
                  imagem: imageBytes);
            },
            child: Text("Salvar"))
      ]),
    );
  }
}
