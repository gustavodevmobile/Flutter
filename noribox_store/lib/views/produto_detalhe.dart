import 'dart:convert';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noribox_store/controllers/produtos_controllers.dart';
import 'package:noribox_store/models/produtos_models.dart';
import 'package:noribox_store/themes/themes.dart';
import 'package:noribox_store/utils/formatters.dart';
import 'package:noribox_store/widgets/app_bar.dart';
import 'package:noribox_store/widgets/calcular_frete.dart';
import 'package:noribox_store/widgets/card_produto.dart';
import 'package:noribox_store/widgets/contador_quantidade.dart';
import 'package:noribox_store/widgets/custom_button.dart';
import 'package:noribox_store/widgets/custom_text_rich.dart';
import 'package:noribox_store/widgets/footer_widget.dart';
import 'package:provider/provider.dart';

class ProdutoDetalheScreen extends StatelessWidget {
  final Produto produto;
  const ProdutoDetalheScreen({super.key, required this.produto});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProdutosController>(
        builder: (context, produtosController, child) {
      return Scaffold(
        backgroundColor: Themes.colorBackground,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(140), child: AppBarWidget()),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  color: Themes.white,
                  borderRadius: BorderRadius.circular(20),
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
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //if (produto.imagem2 != null)
                              CardImageProdutoWidget(
                                width: 100,
                                height: 100,
                                imagemBase64: produto.imagemPrincipal,
                              ),

                              CardImageProdutoWidget(
                                imagemBase64: produto.imagem2 != null
                                    ? produto.imagem2!
                                    : produto.imagemPrincipal,
                              ),

                              CardImageProdutoWidget(
                                imagemBase64: produto.imagem3 != null
                                    ? produto.imagem3!
                                    : produto.imagemPrincipal,
                              ),

                              CardImageProdutoWidget(
                                imagemBase64: produto.imagem4 != null
                                    ? produto.imagem4!
                                    : produto.imagemPrincipal,
                              ),
                            ],
                          ),
                        ),
                        //const SizedBox(width: 16),
                        if (produto.imagemPrincipal.isNotEmpty)
                          Column(
                            children: [
                              CardImageProdutoWidget(
                                imagemBase64: produto.imagemPrincipal,
                                width: 500,
                                height: 600,
                              ),
                              CustomTextRich(
                                textPrimary: 'Código do produto:',
                                fontSizePrimary: 8,
                                colorTextPrimary: Colors.black,
                                textSecondary: '12345678',
                                fontSizeSecondary: 8,
                                isBoldSecondary: true,
                              ),
                            ],
                          ),
                        //Spacer(),
                        const SizedBox(width: 12),
                        Flexible(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  produto.nome,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Roboto',
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                CustomTextRich(
                                  textPrimary: 'Descrição:',
                                  fontSizePrimary: 14,
                                  colorTextPrimary: Colors.black,
                                  textSecondary: produto.descricao,
                                  fontSizeSecondary: 16,
                                  isBoldSecondary: true,
                                ),
                                const SizedBox(height: 6),
                                CustomTextRich(
                                  textPrimary: 'Categoria:',
                                  fontSizePrimary: 14,
                                  colorTextPrimary: Colors.black,
                                  textSecondary: 'Utencílios elétricos',
                                  fontSizeSecondary: 16,
                                  isBoldSecondary: true,
                                ),
                                CustomTextRich(
                                    textPrimary: 'Material:',
                                    fontSizePrimary: 14,
                                    colorTextPrimary: Colors.black,
                                    textSecondary: produto.material,
                                    fontSizeSecondary: 16,
                                    isBoldSecondary: true),

                                CustomTextRich(
                                  textPrimary: 'Dimensões:',
                                  fontSizePrimary: 14,
                                  colorTextPrimary: Colors.black,
                                  textSecondary: produto.dimensoes,
                                  fontSizeSecondary: 16,
                                  isBoldSecondary: true,
                                ),
                                //Text('Material: ${produto.material}'),
                                //Text('Dimensões: ${produto.dimensoes}'),
                                CustomTextRich(
                                  textPrimary: 'Peso:',
                                  fontSizePrimary: 14,
                                  colorTextPrimary: Colors.black,
                                  textSecondary: produto.peso,
                                  fontSizeSecondary: 16,
                                  isBoldSecondary: true,
                                ),
                                const SizedBox(height: 12),
                                Center(
                                  child: ContadorQuantidade(),
                                ),
                                const SizedBox(height: 12),
                                Center(
                                  child: Animate(
                                    effects: [
                                      FadeEffect(
                                          duration: 400.ms, delay: 350.ms),
                                      SlideEffect(
                                          duration: 400.ms,
                                          begin: Offset(0, 0.2)),
                                    ],
                                    child: CustomTextRich(
                                      textPrimary: 'R\$',
                                      fontSizePrimary: 18,
                                      colorTextPrimary: Themes.redPrimary,
                                      textSecondary:
                                          Formatters.formatercurrency(produto
                                              .valorNoPix
                                              .toStringAsFixed(2)),
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
                                            'R\$ ${(produto.valorVenda / 12).toStringAsFixed(2)}',
                                        colorTextSecondary: Themes.redPrimary,
                                        fontSizeSecondary: 18,
                                      ),
                                    ],
                                  ),
                                ),
                                Center(
                                  child: CalculaFreteWidget(
                                    onCalcularFrete: (cep) async {
                                      // Chame sua API de frete aqui e retorne a string do resultado
                                      // Exemplo simulado:
                                      await Future.delayed(
                                          const Duration(seconds: 1));
                                      return 'Frete: R\$ 19,90 - Entrega em até 7 dias úteis';
                                    },
                                  ),
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
                              ],
                            ),
                          ),
                        )
                      ],
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
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                            produto.sobre != null
                                ? Text(
                                    produto.sobre!,
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
                            if (produto.peso != null)
                              CustomTextRich(
                                textPrimary: 'Peso:',
                                fontSizePrimary: 14,
                                colorTextPrimary: Colors.black,
                                textSecondary: produto.peso!,
                                fontSizeSecondary: 16,
                                isBoldSecondary: true,
                                textTertiary: '(aproximadamente)',
                                fontSizeTertiary: 12,
                              ),
                            if (produto.dimensoes != null)
                              CustomTextRich(
                                  textPrimary: 'Dimensões:',
                                  fontSizePrimary: 14,
                                  colorTextPrimary: Colors.black,
                                  textSecondary: produto.dimensoes!,
                                  fontSizeSecondary: 16,
                                  isBoldSecondary: true),
                            if (produto.material != null)
                              CustomTextRich(
                                  textPrimary: 'Material:',
                                  fontSizePrimary: 14,
                                  colorTextPrimary: Colors.black,
                                  textSecondary: produto.material!,
                                  fontSizeSecondary: 16,
                                  isBoldSecondary: true),
                            if (produto.marca != null)
                              CustomTextRich(
                                  textPrimary: 'Marca:',
                                  fontSizePrimary: 14,
                                  colorTextPrimary: Colors.black,
                                  textSecondary: produto.marca!,
                                  fontSizeSecondary: 16,
                                  isBoldSecondary: true),
                            if (produto.cor != null)
                              CustomTextRich(
                                  textPrimary: 'Cor:',
                                  fontSizePrimary: 14,
                                  colorTextPrimary: Colors.black,
                                  textSecondary: produto.cor!,
                                  fontSizeSecondary: 16,
                                  isBoldSecondary: true),
                            if (produto.consumoEletrico != null)
                              CustomTextRich(
                                  textPrimary: 'Consumo Elétrico:',
                                  fontSizePrimary: 14,
                                  colorTextPrimary: Colors.black,
                                  textSecondary: produto.consumoEletrico!,
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
                              produto.sugestoesDeUso ??
                                  'Nenhuma sugestão de uso disponível.',
                              style: const TextStyle(
                                  fontSize: 16, fontFamily: 'Roboto'),
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
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Erro: ${snapshot.error}');
                          } else {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: produtos != null &&
                                        produtos.isNotEmpty
                                    ? produtos!.map((produto) {
                                        return SizedBox(
                                          width: 200, // largura fixa do card
                                          child: CardProduto(
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
                                          ),
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
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _campo(String label, String? valor) {
    if (valor == null || valor.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'Roboto')),
          Expanded(
              child: Text(valor, style: const TextStyle(fontFamily: 'Roboto'))),
        ],
      ),
    );
  }
}

class CardImageProdutoWidget extends StatelessWidget {
  final String imagemBase64;
  final double? width;
  final double? height;

  const CardImageProdutoWidget(
      {this.height, this.width, required this.imagemBase64, super.key});

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        FadeEffect(duration: 600.ms),
        ScaleEffect(duration: 600.ms, curve: Curves.easeOutBack),
      ],
      child: Container(
        width: width ?? 100,
        height: height ?? 100,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black26,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(18),
        margin: const EdgeInsets.only(bottom: 24),
        child: imagemBase64.isNotEmpty
            ? Image.memory(
                base64Decode(imagemBase64!),
                height: 210,
                fit: BoxFit.contain,
              )
            : const Icon(Icons.image_not_supported,
                size: 48, color: Colors.grey),
      ),
    );
  }
}
