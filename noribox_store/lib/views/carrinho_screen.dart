import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:noribox_store/controllers/carrinho_controllers.dart';
import 'package:noribox_store/themes/themes.dart';
import 'package:noribox_store/widgets/app_bar.dart';
import 'package:noribox_store/widgets/calcular_frete.dart';
import 'package:noribox_store/widgets/caminho_produto.dart';
import 'package:noribox_store/widgets/contador_quantidade.dart';
import 'package:noribox_store/widgets/custom_button.dart';
import 'package:noribox_store/widgets/footer_widget.dart';
import 'package:provider/provider.dart';

class CarrinhoScreen extends StatefulWidget {
  const CarrinhoScreen({super.key});

  @override
  State<CarrinhoScreen> createState() => _CarrinhoScreenState();
}

class _CarrinhoScreenState extends State<CarrinhoScreen> {
  List<Map<String, dynamic>> produtos = [
    {
      'id': '1',
      'nome': 'Produto 1',
      'descricao': 'Descrição do Produto 1',
      'preco': 29.99,
      'imagem': 'https://via.placeholder.com/150'
    },
    {
      'id': '2',
      'nome': 'Produto 2',
      'descricao': 'Descrição do Produto 2',
      'preco': 49.99,
      'imagem': 'https://via.placeholder.com/150'
    }
  ];
  @override
  Widget build(BuildContext context) {
    //final carrinhoController = Provider.of<CarrinhoController>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(140),
        child: AppBarWidget(),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1200,
            minWidth: 600,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      Themes.greyLight,
                      Colors.white,
                      Themes.greyLight,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Themes.blackShadow,
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    CaminhoProduto(nomeProduto: 'Carrinho'),
                    Text(
                      'Carrinho de Compras',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Themes.redPrimary,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Themes.greyLight,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: produtos.length,
                                itemBuilder: (context, index) {
                                  final produto = produtos[index];
                                  return Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: ListTile(
                                          onTap: () {
                                            // Aqui você pode adicionar a lógica para navegar para a página de detalhes do produto
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Detalhes do ${produto['nome']}'),
                                              ),
                                            );
                                          },
                                          leading: Icon(
                                            Icons.shopping_cart,
                                            color: Colors.deepPurple,
                                          ),
                                          title: Text(
                                              produto['nome'] ?? 'Produto'),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (produto['descricao'] != null)
                                                Text(produto['descricao']),
                                              if (produto['preco'] != null)
                                                Text(
                                                    'Preço: R\$ ${produto['preco']}'),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(child: ContadorQuantidade()),
                                      const SizedBox(width: 8),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('Total'),
                                          Text(
                                            'R\$ ${produto['preco'] ?? 0}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            produtos.removeAt(index);
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ).animate(
                                effects: [
                                  FadeEffect(duration: 400.ms, delay: 200.ms),
                                  SlideEffect(
                                      duration: 400.ms,
                                      begin: const Offset(0, 0.1)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: SizedBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Themes.greyLight,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 16.0),
                                      child: Column(
                                        children: [
                                          const Text(
                                            'Obter desconto',
                                            style: TextStyle(
                                              color: Themes.redPrimary,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            children: [
                                              Flexible(
                                                flex: 2,
                                                child: TextField(
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    hintText:
                                                        'Digite seu cupom',
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                  ),
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: CustomButton(
                                                  height: 50,
                                                  backgroundColor: Themes.green,
                                                  child: const Text('Aplicar'),
                                                  onPressed: () {},
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ).animate(
                                    effects: [
                                      FadeEffect(
                                          duration: 400.ms, delay: 200.ms),
                                      SlideEffect(
                                          duration: 400.ms,
                                          begin: const Offset(0, 0.1)),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Themes.greyLight,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CalculaFreteWidget(
                                          width: 350,
                                          colorText: Themes.redPrimary,
                                          color: Themes.greyLight,
                                          // onCalcularFrete: (cep) async {
                                          //   final result = '123';
                                          //   // await calcularFrete.calcularFrete(
                                          //   //     cepDestino: cep,
                                          //   //     products: [
                                          //   //       {
                                          //   //         'id': widget.produto.id,
                                          //   //         'width': 23,
                                          //   //         'height': 12,
                                          //   //         'length': 11,
                                          //   //         'weight': 1.2,
                                          //   //       }
                                          //   //     ]);
                                          //   // final extrairValores = calcularFrete
                                          //   //     .extrairValoresServicos(result);
                                          //   // print(
                                          //   //     'Resultado do frete: $result');
                                          //   return result;
                                          // },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    width: 350,
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Themes.greyLight,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: const Text(
                                            'Resumo do pedido',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Subtotal: R\$ 100,00',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Frete: R\$ 19,90',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Total: R\$ 119,90',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Center(
                                          child: CustomButton(
                                            height: 40,
                                            backgroundColor: Themes.green,
                                            child:
                                                const Text('Finalizar compra'),
                                            onPressed: () {
                                              // Aqui você pode adicionar a lógica para finalizar a compra
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Compra finalizada com sucesso!'),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ).animate(
                                    effects: [
                                      FadeEffect(
                                          duration: 400.ms, delay: 200.ms),
                                      SlideEffect(
                                          duration: 400.ms,
                                          begin: const Offset(0, 0.1)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    FooterWidget()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
