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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ElevatedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => cadastroLivro()));
          },
          child: const Icon(Icons.add),
        ));
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

  void _setImageFileListFromFile(XFile? value) {
    _mediaFileList = value == null ? null : <XFile>[value];
  }

  dynamic _pickImageError;
  bool isVideo = false;

  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();

  Future<void> _onImageButtonPressed(
    ImageSource source, {
    required BuildContext context,
    bool isMultiImage = false,
    bool isMedia = false,
  }) async {
    if (_controller != null) {
      await _controller!.setVolume(0.0);
    }
    if (context.mounted) {
      if (isVideo) {
        final XFile? file = await _picker.pickVideo(
            source: source, maxDuration: const Duration(seconds: 10));
        await _playVideo(file);
      } else if (isMultiImage) {
        await _displayPickImageDialog(context, true, (double? maxWidth,
            double? maxHeight, int? quality, int? limit) async {
          try {
            final List<XFile> pickedFileList = isMedia
                ? await _picker.pickMultipleMedia(
                    maxWidth: maxWidth,
                    maxHeight: maxHeight,
                    imageQuality: quality,
                    limit: limit,
                  )
                : await _picker.pickMultiImage(
                    maxWidth: maxWidth,
                    maxHeight: maxHeight,
                    imageQuality: quality,
                    limit: limit,
                  );
            setState(() {
              _mediaFileList = pickedFileList;
            });
          } catch (e) {
            setState(() {
              _pickImageError = e;
            });
          }
        });
      } else if (isMedia) {
        await _displayPickImageDialog(context, false, (double? maxWidth,
            double? maxHeight, int? quality, int? limit) async {
          try {
            final List<XFile> pickedFileList = <XFile>[];
            final XFile? media = await _picker.pickMedia(
              maxWidth: maxWidth,
              maxHeight: maxHeight,
              imageQuality: quality,
            );
            if (media != null) {
              pickedFileList.add(media);
              setState(() {
                _mediaFileList = pickedFileList;
              });
            }
          } catch (e) {
            setState(() {
              _pickImageError = e;
            });
          }
        });
      } else {
        await _displayPickImageDialog(context, false, (double? maxWidth,
            double? maxHeight, int? quality, int? limit) async {
          try {
            final XFile? pickedFile = await _picker.pickImage(
              source: source,
              maxWidth: maxWidth,
              maxHeight: maxHeight,
              imageQuality: quality,
            );
            setState(() {
              _setImageFileListFromFile(pickedFile);
            });
          } catch (e) {
            setState(() {
              _pickImageError = e;
            });
          }
        });
      }
    }
  }

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
            ],
          ),
        ),
      ]),
    );
  }
}
