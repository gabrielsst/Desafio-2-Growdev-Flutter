import 'package:desafio_parte_2/data.dart';
import 'package:flutter/material.dart';

class AdicionarListaPage extends StatelessWidget {
  AdicionarListaPage({super.key});

  final controller = TextEditingController();
  final textKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    final primaryFromPage = Colors.blue;
    final onPrimaryFromPage = Colors.white;

    return Scaffold(
      backgroundColor: primaryFromPage,
      body: SafeArea(
        child: Padding(
          padding: .symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Spacer(flex: 5,),
              Container(
                key: Key('listNameInput'),
                child: TextFormField(
                  key: textKey,
                  onTapOutside: (_) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                  autovalidateMode: .onUserInteraction,
                  validator: (value) {
                    value = (value ?? "").trim();
                
                    if (value.isEmpty) return 'Campo obrigatório';
                
                    return null;
                  },
                  controller: controller,
                  decoration: InputDecoration(
                    hint: Text('Nome da lista'),
                    filled: true,
                    fillColor: onPrimaryFromPage,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(1),
                    )
                  ),
                ),
              ),
              Spacer(flex: 3,),
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      key: Key('backToListsBtn'),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: primaryFromPage,
                        foregroundColor: onPrimaryFromPage,
                        side: BorderSide(color: onPrimaryFromPage)
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }, 
                      child: Text('Voltar'))),
                  SizedBox(width: 10,),
                  Expanded(
                    child: FilledButton(
                      key: Key('createListBtn'),
                      onPressed: () {
                        final nomeLimpo = controller.text.trim();

                        if (nomeLimpo.isEmpty) {
                          textKey.currentState?.validate();
                          return;
                        };

                        Navigator.pop(context, ListaDeProdutos(nome: nomeLimpo, produtos: []));
                      }, 
                      style: FilledButton.styleFrom(
                        backgroundColor: onPrimaryFromPage,
                        foregroundColor: primaryFromPage,
                      ),
                      child: Text('Criar')
                    ),
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}