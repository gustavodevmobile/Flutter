import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:noribox_store/controllers/calcular_frete.dart';
import 'package:noribox_store/controllers/carrinho_controllers.dart';
import 'package:noribox_store/themes/themes.dart';
import 'package:noribox_store/utils/formatters.dart';
import 'package:noribox_store/widgets/app_bar.dart';
import 'package:noribox_store/widgets/button_whatsapp.dart';
import 'package:noribox_store/widgets/calcular_frete.dart';
import 'package:noribox_store/widgets/caminho_produto.dart';
import 'package:noribox_store/widgets/contador_quantidade.dart';
import 'package:noribox_store/widgets/custom_button.dart';
import 'package:noribox_store/widgets/custom_text_rich.dart';
import 'package:noribox_store/widgets/footer_widget.dart';
import 'package:provider/provider.dart';

class CarrinhoScreen extends StatefulWidget {
  const CarrinhoScreen({super.key});

  @override
  State<CarrinhoScreen> createState() => _CarrinhoScreenState();
}

class _CarrinhoScreenState extends State<CarrinhoScreen> {
  @override
  Widget build(BuildContext context) {
    final carrinhoController = Provider.of<CarrinhoController>(context);
    final subtotal = carrinhoController.produtosId.fold<double>(
      0,
      (total, produto) =>
          total + (produto['preco'] * (produto['quantidade'] ?? 1)),
    );
    return Stack(
      children: [
        Scaffold(
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
                  child: ListView(
                    children: [
                      const SizedBox(height: 16),
                      CaminhoProduto(nomeProduto: 'Carrinho'),
                      const SizedBox(height: 16),
                      const Divider(),
                      Center(
                        child: Text(
                          'Carrinho de Compras',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Themes.redPrimary,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 2,
                                child: buildProdutoList(carrinhoController)),
                            const SizedBox(width: 16),
                            Expanded(
                                child: buildResumoCarrinho(
                                    carrinhoController, subtotal)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      FooterWidget()
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        ButtonWhatsapp(),
      ],
    );
  }

  Widget buildProdutoList(CarrinhoController carrinhoController) {
    return Container(
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
      child: carrinhoController.produtosId.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(
                  'Seu carrinho está vazio',
                  style: TextStyle(
                    fontSize: 18,
                    color: Themes.greyPrimary,
                  ),
                ),
              ),
            )
          : ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: carrinhoController.produtosId.length,
              itemBuilder: (context, index) {
                final produto = carrinhoController.produtosId[index];
                return Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ListTile(
                        onTap: () {
                          // Aqui você pode adicionar a lógica para navegar para a página de detalhes do produto
                        },
                        leading: Image.network(produto['imagem']),
                        title: Text(produto['nome'] ?? 'Produto'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (produto['descricao'] != null)
                              Text(produto['descricao']),
                            if (produto['preco'] != null)
                              Text(
                                  'Valor unitário: R\$ ${Formatters.formatercurrency(produto['preco'].toString())}'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                        child: ContadorQuantidade(
                      quantidadeInicial: produto['quantidade'] ?? 1,
                      onQuantidadeChanged: (novaQuantidade) {
                        // Atualiza a quantidade do produto no carrinho
                        setState(() {
                          carrinhoController.produtosId[index]['quantidade'] =
                              novaQuantidade;
                        });
                      },
                    )),
                    const SizedBox(width: 8),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Total'),
                        CustomTextRich(
                            textPrimary: 'R\$',
                            fontSizePrimary: 12,
                            colorTextPrimary: Themes.greyPrimary,
                            textSecondary: Formatters.formatercurrency(
                                (produto['preco'] * (produto['quantidade']))
                                    .toString()),
                            fontSizeSecondary: 16,
                            colorTextSecondary: Themes.redPrimary,
                            isBoldSecondary: true),
                      ],
                    ),
                    SizedBox(
                      width: 100,
                      child: IconButton(
                        icon:
                            const Icon(Icons.delete, color: Themes.redPrimary),
                        onPressed: () {
                          setState(() {
                            carrinhoController.produtosId.removeAt(index);
                          });
                        },
                      ),
                    ),
                  ],
                );
              },
            ).animate(
              effects: [
                FadeEffect(duration: 400.ms, delay: 200.ms),
                SlideEffect(duration: 400.ms, begin: const Offset(0, 0.1)),
              ],
            ),
    );
  }

  Widget buildResumoCarrinho(
      CarrinhoController carrinhoController, double subtotal) {
    final calcularFrete = Provider.of<CalcularFreteController>(context);
    bool hasProduto = carrinhoController.produtosId.isNotEmpty;

    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            //width: 350,
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
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
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            hintText: 'Digite seu cupom',
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 4),
                      CustomButton(
                        height: 50,
                        child: const Text('Aplicar'),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ).animate(
            effects: [
              FadeEffect(duration: 400.ms, delay: 200.ms),
              SlideEffect(duration: 400.ms, begin: const Offset(0, 0.1)),
            ],
          ),
          const SizedBox(height: 20),
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
            child: CalculaFreteWidget(
              hasProduto: hasProduto,
              colorText: Themes.redPrimary,
              color: Themes.greyLight,
              onCalcularFrete: (cep) async {
                final result = await calcularFrete.calcularFrete(
                  cepDestino: cep,
                  products: carrinhoController.produtosId
                      .map((produto) => calcularFrete.criarObjetoCalcularFrete(
                            produto['id'] ?? '',
                            produto['dimensoes'] ?? '0x0x0',
                            produto['peso']?.toString() ?? '0.0',
                          ))
                      .toList(),
                );
                final extrairValores =
                    calcularFrete.extrairValoresServicos(result);
                // print(
                //     'Resultado do frete: $result');
                return extrairValores;
              },
              onSelecionarFrete: (precoFrete) {
                setState(() {
                  // Salve o valor do frete selecionado em uma variável
                  print('Frete selecionado: $precoFrete');
                  // Aqui você pode atualizar o estado do widget ou fazer outras ações necessárias
                });
              },
            ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: const Text(
                    'Resumo do pedido',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Themes.redPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Text(
                      'Subtotal: ',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Themes.greyPrimary),
                    ),
                    const Spacer(),
                    CustomTextRich(
                        textPrimary: 'R\$',
                        fontSizePrimary: 12,
                        colorTextPrimary: Themes.greyPrimary,
                        textSecondary:
                            Formatters.formatercurrency(subtotal.toString()),
                        fontSizeSecondary: 16,
                        colorTextSecondary: Themes.redPrimary,
                        isBoldSecondary: true),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Frete: ',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Themes.greyPrimary,
                      ),
                    ),
                    const Spacer(),
                    CustomTextRich(
                      textPrimary: 'R\$',
                      fontSizePrimary: 12,
                      colorTextPrimary: Themes.greyPrimary,
                      textSecondary: Formatters.formatercurrency('0.00'),
                      fontSizeSecondary: 16,
                      colorTextSecondary: Themes.redPrimary,
                      isBoldSecondary: true,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Divider(),
                Row(
                  children: [
                    Text(
                      'Total: ',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Themes.greyPrimary),
                    ),
                    const Spacer(),
                    CustomTextRich(
                      textPrimary: 'R\$',
                      fontSizePrimary: 12,
                      colorTextPrimary: Themes.greyPrimary,
                      textSecondary:
                          Formatters.formatercurrency(subtotal.toString()),
                      fontSizeSecondary: 16,
                      colorTextSecondary: Themes.redPrimary,
                      isBoldSecondary: true,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                  child: CustomButton(
                    height: 40,
                    child: const Text('Finalizar compra'),
                    onPressed: () {
                      // Aqui você pode adicionar a lógica para finalizar a compra
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Compra finalizada com sucesso!'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ).animate(
            effects: [
              FadeEffect(duration: 400.ms, delay: 200.ms),
              SlideEffect(duration: 400.ms, begin: const Offset(0, 0.1)),
            ],
          ),
        ],
      ),
    );
  }
}
