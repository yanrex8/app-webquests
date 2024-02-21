import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'exibicaopadrao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// executa o app
void main() => runApp(const MainApp());

// classe principal a ser executada
// contém a estrutura com Scaffold + AppBar + Body
class MainApp extends StatelessWidget {
  // construtor
  const MainApp({super.key});
  // o Widget build é semelhante ao main
  @override
  Widget build(BuildContext context) {
    //****adicionar MultiProvider para ter dois ChangeNotifier
    //****MudancaExibicao e MudancaOrientacao
    //****um pra mudar galeria/padrao e outro em pé/deitado
    return ChangeNotifierProvider<MudancaExibicao>(
      create: (context) => MudancaExibicao(),
      child: MaterialApp(
        home: Scaffold(
          // Drawer é a classe responsável pelo menu de hambúrguer
          // Deve ser colocado no Scaffold, mas, por padrão,
          // aparece visualmente no AppBar
          drawer: MenuApp(),
          appBar: AppBar(
            title: Text('WebQuests - Fatec RP'),
            // o elemento actions faz widgets aparecerem do lado direito da AppBar
            actions: [ExibicaoToggle(), BotaoPesquisa()],
          ),
          body: Exibicao(),
        ),
      ),
    );
  }
}

class MenuApp extends StatelessWidget {
  //****para mudar a tela quando clicar na opção usar:
  //****Navigator.of(context).pushNamed('/nome-da-tela');
  //****definir as rotas por meio do elemento "routes" no MaterialApp
  //****por ex: routes: {'/nome-da-tela': (context) => NomeTela()}
  const MenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    //****modo escuro: https://www.kindacode.com/article/flutter-ways-to-make-a-dark-light-mode-toggle/
    //****ChangeNotifier + Consumer ou theme_provider, day_night_switcher...
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Menu'),
          ),
          ListTile(
            title: Text('Opção 1'),
            onTap: () {
              //Navigator.pop(context) fecha o menu mas depende de um context específico
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Opção 2'),
          ),
          ListTile(
            title: Text('Opção 3'),
          ),
        ],
      ),
    );
  }
}

class BotaoPesquisa extends StatelessWidget {
  const BotaoPesquisa({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          padding: EdgeInsets.all(18),
          backgroundColor: Colors.blue),
      child: Icon(Icons.search_rounded),
    );
  }
}

class ExibicaoToggle extends StatefulWidget {
  const ExibicaoToggle({super.key});

  @override
  State<ExibicaoToggle> createState() => _ExibicaoToggleState();
}

class _ExibicaoToggleState extends State<ExibicaoToggle> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MudancaExibicao>(
      builder: (context, model, child) {
        print('o valor é ${model.valor}');
        return RotatedBox(
          quarterTurns: 3,
          child: Switch(
            value: model.valor,
            activeColor: Colors.orange,
            onChanged: (bool novoValor) {
              setState(
                () {
                  model.mudar();
                },
              );
            },
          ),
        );
      },
    );
  }
}

class Exibicao extends StatefulWidget {
  //classe responsável por alternar entre ExibicaoPadrao e ExibicaoGaleria
  const Exibicao({super.key});

  @override
  State<Exibicao> createState() => _ExibicaoState();
}

class _ExibicaoState extends State<Exibicao> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MudancaExibicao>(
      //Consumer aguarda mudanças na classe MudancaExibicao
      //que causarão toda a classe Exibicao ser rebuildada
      builder: (context, model, child) {
        switch (model.valor) {
          case false:
            print('exibicao padrao');
            return ExibicaoPadrao();
          case true:
            print('exibicao galeria');
            return ExibicaoGaleria();
          default:
            print('exibicao padrao');
            return ExibicaoPadrao();
        }
      },
    );
  }
}

class ExibicaoPadrao extends StatelessWidget {
  //****para CRUD com firebase -> firebase_core, cloud_firebase, firebase_storage(imagens)...
  //****Snapshot pra pegar um fluxo de dados
  //****ListView, ListData pra exibir dinamicamente
  //****CircularProgressIndicator() pra símbolo de loading
  const ExibicaoPadrao({super.key});

  @override
  Widget build(BuildContext context) {
    // return ListView.separated(
    //   padding: const EdgeInsets.all(8),
    //   itemCount: 100,
    //   itemBuilder: (BuildContext context, int index) {
    //     return Container();
    //   },
    //   separatorBuilder: (BuildContext context, int index) => const Divider(),
    // );
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: <Widget>[
          ExibicaoWebQuestPadrao(),
          Divider(color: Colors.black),
          ExibicaoWebQuestPadrao(),
          Divider(color: Colors.black),
          ExibicaoWebQuestPadrao(),
          Divider(color: Colors.black),
          ExibicaoWebQuestPadrao(),
          Divider(color: Colors.black),
          ExibicaoWebQuestPadrao(),
          Divider(color: Colors.black),
          ExibicaoWebQuestPadrao(),
          Divider(color: Colors.black),
          //por enquanto é uma exibição repetida e estática só pra fins de exemplo/teste
        ],
      ),
    );
  }
}

class ExibicaoGaleria extends StatelessWidget {
  //****placeholder, deve usar GridView.builder pra fazer a grade de imgs
  //****Image.network() -> getDownloadURL() pra exibir a img
  //****ScrollController para detectar até onde foi scrollado
  //****startAfterDocument pra limitar o número de itens carregados
  const ExibicaoGaleria({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('galeria');
  }
}

class MudancaExibicao extends ChangeNotifier {
  //gerenciador de estado do app no que diz respeito ao modo de exibição
  bool _valor = false;

  bool get valor => _valor;

  void mudar() {
    _valor = !_valor;
    notifyListeners();
  }
}
