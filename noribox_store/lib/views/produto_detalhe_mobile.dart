import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noribox_store/controllers/calcular_frete.dart';
import 'package:noribox_store/controllers/produtos_controllers.dart';
import 'package:noribox_store/models/produtos_models.dart';
import 'package:noribox_store/themes/themes.dart';
import 'package:noribox_store/utils/formatters.dart';
import 'package:noribox_store/views/produto_detalhe.dart';
import 'package:noribox_store/widgets/app_bar.dart';
import 'package:noribox_store/widgets/calcular_frete.dart';
import 'package:noribox_store/widgets/card_image_products.dart';
import 'package:noribox_store/widgets/card_produto.dart';
import 'package:noribox_store/widgets/contador_quantidade.dart';
import 'package:noribox_store/widgets/custom_button.dart';
import 'package:noribox_store/widgets/custom_text_rich.dart';
import 'package:noribox_store/widgets/footer_widget.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ProdutoDetalheMobile extends StatefulWidget {
  final Produto produto;
  const ProdutoDetalheMobile({super.key, required this.produto});

  @override
  State<ProdutoDetalheMobile> createState() => _ProdutoDetalheMobileState();
}

class _ProdutoDetalheMobileState extends State<ProdutoDetalheMobile> {
  late final PageController _pageController;
  int paginaAtual = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final produtosController = Provider.of<ProdutosController>(context);
    final calcularFrete = Provider.of<CalcularFreteController>(context);
    final List<String> imagens = [
      widget.produto.imagemPrincipal,
      if (widget.produto.imagem2 != null && widget.produto.imagem2!.isNotEmpty)
        widget.produto.imagem2!,
      if (widget.produto.imagem3 != null && widget.produto.imagem3!.isNotEmpty)
        widget.produto.imagem3!,
      if (widget.produto.imagem4 != null && widget.produto.imagem4!.isNotEmpty)
        widget.produto.imagem4!,
    ];
    return Container(
      //padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 400, // ajuste conforme necessário
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: imagens.length,
                  onPageChanged: (index) {
                    setState(() {
                      paginaAtual = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return CardImageProdutoWidget(
                      imagemUrl: imagens[index],
                      widtthImage: 220,
                      heightImage: 230,
                      fit: BoxFit.contain,
                    ).animate().shimmer(
                          duration: 800.ms,
                          delay: 200.ms,
                          color: Colors.white70,
                          curve: Curves.easeInOut,
                        );
                  },
                ),
              ),
              Positioned(
                left: 8,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    if (_pageController.hasClients && paginaAtual > 0) {
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    }
                  },
                ),
              ),
              Positioned(
                right: 8,
                child: IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    if (_pageController.hasClients &&
                        paginaAtual < imagens.length - 1) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(),
          Text(
            widget.produto.nome,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
              color: Colors.black87,
            ),
          ),
          CustomTextRich(
            textPrimary: 'Descrição:',
            fontSizePrimary: 14,
            colorTextPrimary: Colors.black,
            textSecondary: widget.produto.descricao,
            fontSizeSecondary: 16,
            isBoldSecondary: true,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  CustomTextRich(
                    textPrimary: 'Categoria:',
                    fontSizePrimary: 14,
                    colorTextPrimary: Colors.black,
                    textSecondary: 'Utensílios',
                    fontSizeSecondary: 16,
                    isBoldSecondary: true,
                  ),
                  CustomTextRich(
                      textPrimary: 'Material:',
                      fontSizePrimary: 14,
                      colorTextPrimary: Colors.black,
                      textSecondary: widget.produto.material,
                      fontSizeSecondary: 16,
                      isBoldSecondary: true),
                  CustomTextRich(
                    textPrimary: 'Dimensões:',
                    fontSizePrimary: 14,
                    colorTextPrimary: Colors.black,
                    textSecondary: widget.produto.dimensoes,
                    fontSizeSecondary: 16,
                    isBoldSecondary: true,
                  ),
                  CustomTextRich(
                    textPrimary: 'Peso:',
                    fontSizePrimary: 14,
                    colorTextPrimary: Colors.black,
                    textSecondary: widget.produto.peso,
                    fontSizeSecondary: 16,
                    isBoldSecondary: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            children: [
              Center(
                child: Animate(
                  effects: [
                    FadeEffect(duration: 400.ms, delay: 350.ms),
                    SlideEffect(duration: 400.ms, begin: Offset(0, 0.2)),
                  ],
                  child: CustomTextRich(
                    textPrimary: 'R\$',
                    fontSizePrimary: 18,
                    colorTextPrimary: Themes.redPrimary,
                    textSecondary: Formatters.formatercurrency(
                        widget.produto.valorNoPix.toStringAsFixed(2)),
                    fontSizeSecondary: 40,
                    colorTextSecondary: Themes.redPrimary,
                    isBoldSecondary: true,
                    textTertiary: '(no pix)',
                    fontSizeTertiary: 14,
                    colorTextTertiary: Themes.green,
                  ),
                ),
              ),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextRich(
                      textPrimary: 'ou em até',
                      textSecondary: '12x',
                      fontSizePrimary: 14,
                      colorTextSecondary: Themes.redPrimary,
                      fontSizeSecondary: 18,
                    ),
                    const SizedBox(width: 4),
                    CustomTextRich(
                      textPrimary: 'de',
                      fontSizePrimary: 14,
                      textSecondary:
                          'R\$ ${(widget.produto.valorVenda / 12).toStringAsFixed(2)}',
                      colorTextSecondary: Themes.redPrimary,
                      fontSizeSecondary: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Center(
            child: ContadorQuantidade(),
          ),
          // const SizedBox(height: 12),
          !widget.produto.freteGratis
              ? Center(
                  child: CalculaFreteWidget(
                    onCalcularFrete: (cep) async {
                      final result = await calcularFrete
                          .calcularFrete(cepDestino: cep, products: [
                        {
                          'id': widget.produto.id,
                          'width': 23,
                          'height': 12,
                          'length': 11,
                          'weight': 1.2,
                        }
                      ]);
                      final extrairValores =
                          calcularFrete.extrairValoresServicos(result);
                      // print(
                      //     'Resultado do frete: $result');
                      return extrairValores;
                    },
                  ),
                )
              : Column(
                  children: [
                    Text(
                      'Frete Grátis',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Themes.green),
                    ),
                    Text(Formatters.dataEntregaFormatada(12))
                  ],
                ),
          Center(
            child: CustomButton(
              onPressed: () {},
              width: 200,
              height: 50,
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              borderRadius: 12,
              elevation: 2,
              child: Text('Adicionar ao Carrinho'),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(),
          Center(
            child: Text(
              'Informações do Produto',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Themes.redPrimary),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sobre o produto:',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Themes.redPrimary),
                  ),
                  widget.produto.sobre != null
                      ? Text(
                          widget.produto.sobre!,
                          style: GoogleFonts.robotoCondensed(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        )
                      : const Text(
                          'Nenhuma informação adicional disponível.',
                          style: TextStyle(fontSize: 16, fontFamily: 'Roboto'),
                        ),
                  const SizedBox(height: 20),
                  Text(
                    'Caracteristicas:',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Themes.redPrimary),
                  ),
                  if (widget.produto.peso != null)
                    CustomTextRich(
                      textPrimary: 'Peso:',
                      fontSizePrimary: 14,
                      colorTextPrimary: Colors.black,
                      textSecondary: widget.produto.peso!,
                      fontSizeSecondary: 16,
                      isBoldSecondary: true,
                      textTertiary: '(aproximadamente)',
                      fontSizeTertiary: 12,
                    ),
                  if (widget.produto.dimensoes != null)
                    CustomTextRich(
                        textPrimary: 'Dimensões:',
                        fontSizePrimary: 14,
                        colorTextPrimary: Colors.black,
                        textSecondary: widget.produto.dimensoes!,
                        fontSizeSecondary: 16,
                        isBoldSecondary: true),
                  if (widget.produto.material != null)
                    CustomTextRich(
                        textPrimary: 'Material:',
                        fontSizePrimary: 14,
                        colorTextPrimary: Colors.black,
                        textSecondary: widget.produto.material!,
                        fontSizeSecondary: 16,
                        isBoldSecondary: true),
                  if (widget.produto.marca != null)
                    CustomTextRich(
                        textPrimary: 'Marca:',
                        fontSizePrimary: 14,
                        colorTextPrimary: Colors.black,
                        textSecondary: widget.produto.marca!,
                        fontSizeSecondary: 16,
                        isBoldSecondary: true),
                  if (widget.produto.cor != null)
                    CustomTextRich(
                        textPrimary: 'Cor:',
                        fontSizePrimary: 14,
                        colorTextPrimary: Colors.black,
                        textSecondary: widget.produto.cor!,
                        fontSizeSecondary: 16,
                        isBoldSecondary: true),
                  if (widget.produto.consumoEletrico != null)
                    CustomTextRich(
                        textPrimary: 'Consumo Elétrico:',
                        fontSizePrimary: 14,
                        colorTextPrimary: Colors.black,
                        textSecondary: widget.produto.consumoEletrico!,
                        fontSizeSecondary: 16,
                        isBoldSecondary: true),
                  const SizedBox(height: 20),
                  Text(
                    'Recomendações de uso:',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Themes.redPrimary),
                  ),
                  Text(
                    widget.produto.sugestoesDeUso ??
                        'Nenhuma sugestão de uso disponível.',
                    style: const TextStyle(fontSize: 16, fontFamily: 'Roboto'),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          FutureBuilder(
              future: produtosController.buscarProdutos(),
              builder: (context, snapshot) {
                final produtos = snapshot.data;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Erro: ${snapshot.error}');
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: produtos != null && produtos.isNotEmpty
                          ? produtos.map((produto) {
                              return CardProduto(
                                produto: produto,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProdutoDetalheScreen(
                                              produto: produto),
                                    ),
                                  );
                                  //abrirTelaCheckout(context, produto);
                                },
                              );
                            }).toList()
                          : [
                              const Text(
                                'Nenhum produto encontrado.',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Roboto',
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                    ),
                  );
                }
              }),
          FooterWidget()
        ],
      ),
    );
  }
}
