import 'package:flutter_animate/flutter_animate.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noribox_store/controllers/calcular_frete.dart';
import 'package:noribox_store/controllers/carrinho_controllers.dart';
import 'package:noribox_store/controllers/produtos_controllers.dart';
import 'package:noribox_store/models/produtos_models.dart';
import 'package:noribox_store/themes/themes.dart';
import 'package:noribox_store/utils/formatters.dart';
import 'package:noribox_store/widgets/button_whatsapp.dart';
import 'package:noribox_store/widgets/icon_favorito.dart';
import 'package:noribox_store/views/produto_detalhe_mobile.dart';
import 'package:noribox_store/widgets/app_bar.dart';
import 'package:noribox_store/widgets/avaliacao_produto.dart';
import 'package:noribox_store/widgets/avaliacao_usuario.dart';
import 'package:noribox_store/widgets/calcular_frete.dart';
import 'package:noribox_store/widgets/caminho_produto.dart';
import 'package:noribox_store/widgets/card_image_products.dart';
import 'package:noribox_store/widgets/card_produto.dart';
import 'package:noribox_store/widgets/contador_quantidade.dart';
import 'package:noribox_store/widgets/custom_button.dart';
import 'package:noribox_store/widgets/custom_text_rich.dart';
import 'package:noribox_store/widgets/footer_widget.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ProdutoDetalheScreen extends StatefulWidget {
  final Produto produto;
  const ProdutoDetalheScreen({super.key, required this.produto});

  @override
  State<ProdutoDetalheScreen> createState() => _ProdutoDetalheScreenState();
}

class _ProdutoDetalheScreenState extends State<ProdutoDetalheScreen> {
  final hoje = DateTime.now();
  late final DateTime dataEntrega;
  late final String dataFormatada;
  late final ValueNotifier<String> imagemCentralNotifier;
  int quantidade = 1;

  @override
  void initState() {
    super.initState();
    dataEntrega = hoje.add(const Duration(days: 12));
    dataFormatada = DateFormat('dd/MM/yyyy').format(dataEntrega);
    imagemCentralNotifier = ValueNotifier(widget.produto.imagemPrincipal);
  }

  void atualizarImagemCentral(String novaImagem) {
    if (imagemCentralNotifier.value != novaImagem) {
      imagemCentralNotifier.value = novaImagem;
    }
  }

  final avaliacoesMock = [
    AvaliacaoUsuario(
      nome: 'Maria Silva',
      comentario: 'Produto excelente, superou minhas expectativas!',
      nota: 5,
      data: DateTime(2025, 7, 10),
    ),
    AvaliacaoUsuario(
      nome: 'João Souza',
      comentario: 'Chegou rápido, mas a embalagem veio um pouco amassada.',
      nota: 4,
      data: DateTime(2025, 7, 8),
    ),
    AvaliacaoUsuario(
      nome: 'Ana Paula',
      comentario: 'Gostei bastante, recomendo para todos.',
      nota: 5,
      data: DateTime(2025, 7, 5),
    ),
    AvaliacaoUsuario(
      nome: 'Carlos Mendes',
      comentario: 'Produto bom, mas poderia ser mais barato.',
      nota: 3,
      data: DateTime(2025, 7, 2),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final produtosController = Provider.of<ProdutosController>(context);
    final calcularFrete = Provider.of<CalcularFreteController>(context);
    final carrinhoController =
        Provider.of<CarrinhoController>(context, listen: false);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Themes.colorBackground,
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(140), child: AppBarWidget()),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: LayoutBuilder(builder: (context, constraints) {
                  if (constraints.maxWidth < 850) {
                    return ProdutoDetalheMobile(
                      produto: widget.produto,
                    );
                  }
                  return Container(
                    decoration: BoxDecoration(
                      color: Themes.white,
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          Themes.greyLight,
                          Colors.white,
                          Themes.greyTertiary,
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),
                        CaminhoProduto(nomeProduto: widget.produto.nome),
                        // CustomTextRich(
                        //   textPrimary: 'Código do produto:',
                        //   fontSizePrimary: 8,
                        //   colorTextPrimary: Colors.black,
                        //   textSecondary: '12345678',
                        //   fontSizeSecondary: 8,
                        //   isBoldSecondary: true,
                        // ),
                        const SizedBox(height: 18),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildImagensMiniatura(),
                              if (widget.produto.imagemPrincipal.isNotEmpty)
                                buildImagemPrincipal(),
                              //Spacer(),
                              const SizedBox(width: 20),
                              buildResumoProduto(
                                  carrinhoController, calcularFrete),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
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
                          padding: const EdgeInsets.all(16.0),
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
                                        style: TextStyle(
                                            fontSize: 16, fontFamily: 'Roboto'),
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
                                      textSecondary:
                                          widget.produto.consumoEletrico!,
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
                                  style: const TextStyle(
                                      fontSize: 16, fontFamily: 'Roboto'),
                                ),
                                const SizedBox(height: 20),
                                Divider(
                                  color: Colors.black26,
                                  thickness: 1,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Avaliações',
                                    style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Themes.redPrimary),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ListaAvaliacoesProduto(
                                    avaliacoes: avaliacoesMock),
                                const SizedBox(height: 20),
                                Center(
                                  child: CustomButton(
                                    onPressed: () {},
                                    width: 200,
                                    height: 50,
                                    borderRadius: 12,
                                    elevation: 2,
                                    child: Text('Adicionar Avaliação'),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Divider(
                                  color: Colors.black26,
                                  thickness: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: FutureBuilder(
                              future: produtosController.buscarProdutos(),
                              builder: (context, snapshot) {
                                final produtos = snapshot.data;
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Text('Erro: ${snapshot.error}');
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Wrap(
                                      spacing: 16,
                                      runSpacing: 16,
                                      children: produtos != null &&
                                              produtos.isNotEmpty
                                          ? produtos.map((produto) {
                                              return CardProduto(
                                                produto: produto,
                                                onTapCard: () {
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
                        ),

                        FooterWidget(),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
        ButtonWhatsapp(),
      ],
    );
  }

  Widget buildImagensMiniatura() {
    return Expanded(
      child: MouseRegion(
        onExit: (event) =>
            atualizarImagemCentral(widget.produto.imagemPrincipal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MouseRegion(
              onEnter: (_) =>
                  atualizarImagemCentral(widget.produto.imagemPrincipal),
              child: CardImageProdutoWidget(
                fit: BoxFit.contain,
                isBorder: true,
                imagemUrl: widget.produto.imagemPrincipal,
              ),
            ),
            MouseRegion(
              onEnter: (_) => atualizarImagemCentral(
                  widget.produto.imagem2 ?? widget.produto.imagemPrincipal),
              child: CardImageProdutoWidget(
                fit: BoxFit.contain,
                isBorder: true,
                imagemUrl: widget.produto.imagem2 != null
                    ? widget.produto.imagem2!
                    : widget.produto.imagemPrincipal,
              ),
            ),
            MouseRegion(
              onEnter: (_) => atualizarImagemCentral(
                  widget.produto.imagem3 ?? widget.produto.imagemPrincipal),
              child: CardImageProdutoWidget(
                fit: BoxFit.contain,
                isBorder: true,
                imagemUrl: widget.produto.imagem3 != null
                    ? widget.produto.imagem3!
                    : widget.produto.imagemPrincipal,
              ),
            ),
            MouseRegion(
              onEnter: (_) => atualizarImagemCentral(
                  widget.produto.imagem4 ?? widget.produto.imagemPrincipal),
              child: CardImageProdutoWidget(
                isBorder: true,
                fit: BoxFit.cover,
                padding: 0.0,
                imagemUrl: widget.produto.imagem4 != null
                    ? widget.produto.imagem4!
                    : widget.produto.imagemPrincipal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImagemPrincipal() {
    return Column(
      children: [
        ValueListenableBuilder(
            valueListenable: imagemCentralNotifier,
            builder: (context, imagem, _) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: CardImageProdutoWidget(
                  key: ValueKey(
                      '${imagem}_${DateTime.now().millisecondsSinceEpoch}'),
                  imagemUrl: imagem,
                  width: 500,
                  height: 500,
                  widtthImage: 400,
                  heightImage: 400,
                  fit: BoxFit.contain,
                  isBorder: true,
                ),
              );
            }),
        AvaliacoesProdutoWidget(notaMedia: 5, quantidadeAvaliacoes: 4),
      ],
    );
  }

  Widget buildResumoProduto(CarrinhoController carrinhoController,
      CalcularFreteController calcularFrete) {
    return Flexible(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            widget.produto.nome,
            textAlign: TextAlign.center,
            style: GoogleFonts.aboreto(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Themes.redPrimary,
            ),
          ),
          //const SizedBox(height: 6),
          Text(
            widget.produto.descricao,
            textAlign: TextAlign.center,
            style: GoogleFonts.aboreto(
              fontSize: 16,
              color: Themes.redPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
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
            textTertiary: 'cm',
            fontSizeTertiary: 12,
            colorTextTertiary: Colors.black54,
          ),
          CustomTextRich(
            textPrimary: 'Peso:',
            fontSizePrimary: 14,
            colorTextPrimary: Colors.black,
            textSecondary: widget.produto.peso,
            fontSizeSecondary: 16,
            isBoldSecondary: true,
            textTertiary: 'kg',
            fontSizeTertiary: 12,
            colorTextTertiary: Colors.black54,
          ),
          const SizedBox(height: 12),
          Center(
            child: ContadorQuantidade(
              quantidadeInicial: 1,
              onQuantidadeChanged: (qtd) {
                quantidade = qtd;
                if (carrinhoController.produtosId.isNotEmpty) {
                  carrinhoController.atualizarQuantidade(
                      widget.produto.id, qtd);
                }
              },
            ),
          ),
          const SizedBox(height: 12),
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
          !widget.produto.freteGratis
              ? Center(
                  child: CalculaFreteWidget(
                    isBorder: true,
                    onCalcularFrete: (cep) async {
                      final result = await calcularFrete
                          .calcularFrete(cepDestino: cep, products: [
                        calcularFrete.criarObjetoCalcularFrete(
                            widget.produto.id,
                            widget.produto.dimensoes ?? '0x0x0',
                            widget.produto.peso ?? '0.0'),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconFavorito(),
              const SizedBox(width: 4),
              Flexible(
                flex: 2,
                child: CustomButton(
                  onPressed: () {
                    carrinhoController.adicionarProduto({
                      'id': widget.produto.id,
                      'nome': widget.produto.nome,
                      'descricao': widget.produto.descricao,
                      'quantidade': quantidade,
                      'preco': widget.produto.valorComJuros,
                      'imagem': widget.produto.imagemPrincipal
                    });
                  },
                  width: 200,
                  height: 50,
                  borderRadius: 12,
                  elevation: 2,
                  child: Text('Adicionar ao Carrinho'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
