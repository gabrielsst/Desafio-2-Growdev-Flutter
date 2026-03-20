import 'package:desafio_parte_2/data.dart';
import 'package:desafio_parte_2/pages/adicionar-lista/adicionar_lista.page.dart';
import 'package:desafio_parte_2/pages/gerenciar-lista/gerenciar_lista.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final double imageWidth = size.width / 5;

    return Scaffold(
      appBar: AppBar(title:Text('Minhas Listas', key: Key('appBarTitle'),), 
      actions: [Icon(Icons.diamond, color: Colors.yellow,)],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            CupertinoPageRoute(builder: (_) => AdicionarListaPage()),
          );

          if (result == null) return;

          listaDeListas.add(result);
        },
        shape: CircleBorder(),
        key: Key('addListBtn'),
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 25, vertical: 10),
          child: Center(
            child: listaDeListas.isEmpty ? Column(
              mainAxisAlignment: .center,
              children: [
                Image.asset('assets/images/lista-de-compras.png', width: imageWidth, key: Key('emptyListImage'),),
                SizedBox(height: 25),
                Text('Crie sua primeira lista\nToque no botão azul'),
              ],
            )
            : ListView.builder(
              itemCount: listaDeListas.length,
              itemBuilder: (context, index) {
                final listaDeProdutos = listaDeListas[index];
                return InkWell(
                  key: Key('shoppingListCard'),
                  onTap: () async { 
                    final listaEditada = await Navigator.push(
                      context, 
                      CupertinoPageRoute(
                        builder: (_) => GerenciarListaPage(
                          listaDeProdutos: listaDeProdutos
                        ),
                      ),
                    );

                    if (listaEditada is! ListaDeProdutos) return;

                    listaDeListas[index] = listaEditada;
                  },
                  child: Card(
                    elevation: 3,
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(listaDeProdutos.nome),
                          trailing: Text(
                            '${listaDeProdutos.produtosComprados.length}/${listaDeProdutos.totalDeProdutos}',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Padding(
                          padding: .only(
                            bottom: 25,
                            top: 10,
                            right: 10,
                            left: 10
                          ),
                          child: LinearProgressIndicator(
                            value: listaDeProdutos.percentualComprado,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}