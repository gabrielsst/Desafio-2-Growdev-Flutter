List<ListaDeProdutos> listaDeListas = [];

class ListaDeProdutos {
  final String nome;
  final List<Produto> produtos;
  int get totalDeProdutos => produtos.length;
  List<Produto> get produtosComprados => produtos.where((p) => p.comprado).toList();
  List<Produto> get produtosNaoComprados => produtos.where((p) => !p.comprado).toList();
  double get percentualComprado {
    if (produtos.isEmpty) return 0.0;

    return produtosComprados.length / totalDeProdutos;
  }

  const ListaDeProdutos({required this.nome, required this.produtos});
}

class Produto {
  final String nome;
  final double preco;
  final bool comprado;

  const Produto({required this.comprado, required this.nome, required this.preco});

  Produto copyWith({bool? comprado}) {
    return Produto(
      nome: nome,
      preco: preco,
      comprado: comprado ?? this.comprado,
    );
  }
}