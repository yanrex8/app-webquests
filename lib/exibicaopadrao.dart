import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:provider/provider.dart';

class ExibicaoWebQuestPadrao extends StatefulWidget {
  const ExibicaoWebQuestPadrao({super.key});

  @override
  State<StatefulWidget> createState() => _ExibicaoWebQuestPadraoState();
}

class _ExibicaoWebQuestPadraoState extends State<ExibicaoWebQuestPadrao>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double altura = MediaQuery.of(context).size.height;
    double largura = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.blue,
      ),
      width: largura * 0.9,
      height: altura * 0.6,
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabAlignment: TabAlignment.fill,
            dividerColor: Colors.white,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.circle),
              ),
              Tab(
                icon: Icon(Icons.circle),
              ),
              Tab(
                icon: Icon(Icons.circle),
              ),
              Tab(
                icon: Icon(Icons.circle),
              ),
            ],
          ),
          Divider(
            //implementar a foto de fundo
            color: Colors.white,
          ),
          Expanded(
              child: TabBarView(controller: _tabController, children: <Widget>[
            Column(
              children: <Widget>[
                ExibicaoPadraoTitulo(
                    altura: altura, largura: largura, titulo: 'TÍTULO'),
                ExibicaoPadraoDados(
                    autores: ['Yan Guilherme Ribon'],
                    orientador: 'Edilene',
                    grandeArea: 'Informática'),
                Expanded(
                    child: TextoExpansivel(
                        texto:
                            '',
                        altura: altura,
                        largura: largura))
              ],
            ),
            Text('b'),
            Text('c'),
            Text('d'),
          ]))
        ],
      ),
    );
  }
}

class ExibicaoPadraoDados extends StatelessWidget {
  const ExibicaoPadraoDados(
      {super.key,
      required this.autores,
      required this.orientador,
      required this.grandeArea});

  final List<String> autores;
  final String orientador;
  final String grandeArea;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 20.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 30.0),
                  color: Colors.red,
                  child: Text(
                      textScaleFactor: 1.5, textAlign: TextAlign.left, 'Autor'),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.green,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(textScaleFactor: 1.0, autores[0]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 20.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 30.0),
                  color: Colors.red,
                  child: Text(
                      textScaleFactor: 1.5,
                      textAlign: TextAlign.left,
                      'Orientador'),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.green,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(textScaleFactor: 1.0, orientador),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 20.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 30.0),
                  color: Colors.red,
                  child: Text(
                      textScaleFactor: 1.5,
                      textAlign: TextAlign.left,
                      'Grande Área'),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.green,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(textScaleFactor: 1.0, grandeArea),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ExibicaoPadraoTitulo extends StatelessWidget {
  ExibicaoPadraoTitulo(
      {super.key,
      required this.altura,
      required this.largura,
      required this.titulo});

  final double altura;
  final double largura;
  final String titulo;
  final Future firestore = FirebaseFirestore.instance
      .collection('webquests')
      .doc('quest1')
      .collection('tabs')
      .doc('introduction')
      .get();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: altura * 0.2,
      width: largura * 0.7,
      decoration: BoxDecoration(
        //fazer funcionar (não sei a sintaxe de integração entre firebase e flutter 😢)
        //image: Image.network(firestore.then((DocumentSnapshot doc) {
          //final data = doc.data as Map<String, dynamic>;
        //})),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Text(textScaleFactor: 1.5, titulo),
    );
  }
}

class TextoExpansivel extends StatefulWidget {
  const TextoExpansivel(
      {super.key,
      required this.texto,
      required this.altura,
      required this.largura});

  final String texto;
  final double altura;
  final double largura;

  @override
  State<StatefulWidget> createState() => _TextoExpansivelState();
}

class _TextoExpansivelState extends State<TextoExpansivel> {
  late String comeco;
  late String resto;

  bool lerMais = false;

  @override
  void initState() {
    super.initState();

    if (widget.texto.length > 50) {
      comeco = widget.texto.substring(0, 50);
      resto = widget.texto.substring(50, widget.texto.length);
    } else {
      comeco = widget.texto;
      resto = "";
    }
  }
  //ler mais: implementar expansão do container
  //texto sem expansão: exibir a opção ler mais + ter um tamanha/numero de caracteres máximo
  //texto expandido: expandir o container do texto e também todo o widget da webquest
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: widget.altura * 0.15,
      width: widget.largura * 0.8,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
      padding: EdgeInsets.all(10.0),
      child: resto.isEmpty
          ? Text(comeco)
          : Column(
              children: <Widget>[
                Text(
                  lerMais ? (comeco + resto) : ('$comeco ...'),
                ),
                InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        lerMais ? 'ler menos' : 'ler mais',
                        style: TextStyle(color: Colors.blue),
                      )
                    ],
                  ),
                  onTap: () {
                    setState(
                      () {
                        lerMais = !lerMais;
                      },
                    );
                  },
                ),
              ],
            ),
    );
  }
}
