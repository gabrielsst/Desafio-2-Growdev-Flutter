import 'package:brasil_fields/brasil_fields.dart';
import 'package:desafio_parte_2/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GerenciarListaPage extends StatefulWidget {
  final ListaDeProdutos listaDeProdutos;
  
  const GerenciarListaPage({super.key, required this.listaDeProdutos});

  @override
  State<GerenciarListaPage> createState() => _GerenciarListaPageState();
}

class _GerenciarListaPageState extends State<GerenciarListaPage> {
  late final listaDeProdutos = ListaDeProdutos(
    nome: widget.listaDeProdutos.nome,
    produtos: List.of(widget.listaDeProdutos.produtos),
  );
  
  @override
  Widget build(BuildContext context) {
    final firstColor = Colors.blue;
    final secondColor = Colors.white;
    final thirdColor = Colors.green;

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            key: Key('updateListBtn'),
            onPressed: () => Navigator.pop(context, listaDeProdutos), 
            child: Text('Atualizar')
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: Key('addNewItemBtn'),
        backgroundColor: firstColor,
        onPressed: adicionarNovoProduto,
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(50)),
        label: Text('Adicionar', style: TextStyle(color: secondColor, fontWeight: .bold),),
      ),
      body: SafeArea(
        child: Padding(
          padding: .symmetric(horizontal: 25, vertical: 10),
          child: Column(
            children: [
              Align(
                alignment: .centerLeft,
                child: Text(
                  listaDeProdutos.nome,  
                  style: TextStyle(fontWeight: .bold, fontSize: 22),            
                ),
              ),
              Divider(),
              ListView.builder(
                itemCount: listaDeProdutos.produtos.length, 
                shrinkWrap: true,
                itemBuilder: (context, index) {
                final Produto produto = listaDeProdutos.produtos[index];
                
                return ListTile(
                  key: Key('productCheckbox'),
                  onTap: () {
                    setState(() {
                      listaDeProdutos.produtos[index] = produto.copyWith(
                        comprado: !produto.comprado,
                      );
                    });
                  },
                  leading: produto.comprado
                      ? Icon(Icons.check_circle, color: thirdColor,)
                      : Icon(Icons.circle_outlined, color: firstColor,),
                  title: Text(produto.nome),
                  trailing: Text(
                    produto.preco.toStringAsFixed(2),
                    style: TextStyle(fontSize: 15),
                  ),
                );
              }
            ),
            Row(
              children: [
                Column(children: [Text('Não marcados'), Text('R\$ ${listaDeProdutos.produtosNaoComprados.fold(0.0, (acc, p) => acc += p.preco).toStringAsFixed(2)}', style: TextStyle(color: Colors.blue),)],),
                SizedBox(width: 10,),
                Column(children: [Text('Marcados'), Text('R\$ ${listaDeProdutos.produtosComprados.fold(0.0, (acc, p) => acc += p.preco).toStringAsFixed(2)}', style: TextStyle(color: thirdColor),)],),
              ],
            ),
            ],
          ),
        ),
      ),
    );
  }

  void adicionarNovoProduto() async {
    final result = await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      showDragHandle: true,
      builder: (context) {
        return AdicionarNovoProduto();
      },
    );

    if(result is! Produto) return;

    setState(() {
      listaDeProdutos.produtos.add(result);
    });
  }
}

class AdicionarNovoProduto extends StatefulWidget {
  AdicionarNovoProduto({super.key});

  @override
  State<AdicionarNovoProduto> createState() => _AdicionarNovoProdutoState();
}

class _AdicionarNovoProdutoState extends State<AdicionarNovoProduto> {
  final nameController = TextEditingController();
  final precoController = TextEditingController();

  final nomeKey = GlobalKey<FormFieldState>();
  final precoKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    final firstColor = Colors.blue;

    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, MediaQuery.viewInsetsOf(context).bottom + 25),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
            Text('Adicione Item'),
            CloseButton()
            ],
          ),
          Divider(),
          SizedBox(height: 10,),
          TextFormField(
            key: Key('inputItem'),
            controller: nameController  ,
            autovalidateMode: .always,
            validator: (value) {
              value = value ?? '';

              if (value.isEmpty) return 'Campo obrigatório';

              return null;
            },
            decoration: InputDecoration(hint: Text('Nome do item'), border: .none),
          ),
          Container(
            key: Key('inputValue'),
            child: TextFormField(
              key: precoKey,
              controller: precoController,
              keyboardType: .number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CentavosInputFormatter(moeda: true),
              ],
              autovalidateMode: .always,
              validator: (value) {
                value = value ?? '';
            
                if (value.isEmpty) return 'Campo obrigatório';
            
                return null;
              },
              decoration: InputDecoration(hint: Text('R\$ 0,00'), border: .none),
            ),
          ),
          Align(
            alignment: .centerRight,
            child: OutlinedButton(
              key: Key('addItemBtn'),
              style: OutlinedButton.styleFrom(side: BorderSide.none),
              onPressed: () {
              final name = nameController.text;
              String preco = precoController.text; 
              preco = preco.split(' ').last.replaceAll(',', '.');

              if(name.isEmpty) return;

              final precoTratado = double.tryParse(preco) ?? 0.00;

              Navigator.pop(
                context,
                Produto(
                  nome: name,
                  preco: precoTratado,
                  comprado: false,
                ),
              );
            }, 
            child: Text('Adicionar', style: TextStyle(color: firstColor),)),
          )
        ],
      ),
    );
  }
}