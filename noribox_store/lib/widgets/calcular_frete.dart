import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:noribox_store/themes/themes.dart';
import 'package:noribox_store/utils/formatters.dart';
import 'package:noribox_store/widgets/custom_text_rich.dart';

class CalculaFreteWidget extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> Function(String cep)?
      onCalcularFrete;

  const CalculaFreteWidget({super.key, this.onCalcularFrete});

  @override
  State<CalculaFreteWidget> createState() => _CalculaFreteWidgetState();
}

class _CalculaFreteWidgetState extends State<CalculaFreteWidget> {
  final _cepController = TextEditingController();
  List<Map<String, dynamic>>? _resultado;
  bool _loading = false;
  String? _erro;

  void _calcular() async {
    setState(() {
      _loading = true;
      _resultado = null;
      _erro = null;
    });
    try {
      if (widget.onCalcularFrete != null) {
        final res = await widget.onCalcularFrete!(_cepController.text);
        //print('Resultado do frete: $res');
        setState(() => _resultado = res);
      } else {
        // Simulação de resultado
        await Future.delayed(const Duration(seconds: 1));
        // setState(() =>
        //     _resultado = 'Frete: R\$ 19,90 - Entrega em até 7 dias úteis');
      }
    } catch (e) {
      setState(() => _erro = 'Erro ao calcular frete');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        FadeEffect(duration: 400.ms, delay: 200.ms),
        SlideEffect(duration: 400.ms, begin: const Offset(0, 0.1)),
      ],
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Text('Frete e prazo de entrega'),
            Container(
              width: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextFormField(
                        inputFormatters: [Formatters.cepFormatter],
                        controller: _cepController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Digite seu CEP',
                          border: InputBorder.none,
                          //isDense: true,
                        ),
                        //maxLength: 9,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _loading ? null : _calcular,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Calcular'),
                    ),
                  ],
                ),
              ),
            ),
            if (_resultado != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Column(
                  children: _resultado!.map((item) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 70,
                              height: 30,
                              child: Image.asset(
                                item['imagemServico'],
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 8),
                            CustomTextRich(
                              textPrimary: 'R\$',
                              fontSizePrimary: 10,
                              colorTextPrimary: Themes.greyPrimary,
                              textSecondary: Formatters.formatercurrency(
                                  item['preco'].toString()),
                              fontSizeSecondary: 16,
                              colorTextSecondary: Themes.redPrimary,
                              textTertiary: ' - ${item['prazoEntrega']} dias úteis',
                              fontSizeTertiary: 14,
                              colorTextTertiary: Themes.greyPrimary,
                            )
                            // Text(
                            //   'R\$ ${item['preco'].toString()} -',
                            //   style: const TextStyle(
                            //     fontSize: 18,
                            //   ),
                            // ),
                            // const SizedBox(width: 8),
                            // Text(
                            //   '${item['prazoEntrega']} dias úteis',
                            //   style: const TextStyle(
                            //     fontSize: 18,
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            if (_erro != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  _erro!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter_animate/flutter_animate.dart';

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:noribox_store/controllers/calcular_frete.dart';
// import 'package:noribox_store/controllers/produtos_controllers.dart';
// import 'package:noribox_store/models/produtos_models.dart';
// import 'package:noribox_store/themes/themes.dart';
// import 'package:noribox_store/utils/formatters.dart';
// import 'package:noribox_store/widgets/app_bar.dart';
// import 'package:noribox_store/widgets/calcular_frete.dart';
// import 'package:noribox_store/widgets/card_produto.dart';
// import 'package:noribox_store/widgets/contador_quantidade.dart';
// import 'package:noribox_store/widgets/custom_button.dart';
// import 'package:noribox_store/widgets/custom_text_rich.dart';
// import 'package:noribox_store/widgets/footer_widget.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';

// class ProdutoDetalheScreen extends StatefulWidget {
//   final Produto produto;
//   const ProdutoDetalheScreen({super.key, required this.produto});

//   @override
//   State<ProdutoDetalheScreen> createState() => _ProdutoDetalheScreenState();
// }

// class _ProdutoDetalheScreenState extends State<ProdutoDetalheScreen> {
//   final hoje = DateTime.now();
//   late final DateTime dataEntrega;
//   late final String dataFormatada;
//   late final ValueNotifier<String> imagemCentralNotifier;

//   @override
//   void initState() {
//     super.initState();
//     dataEntrega = hoje.add(const Duration(days: 12));
//     dataFormatada = DateFormat('dd/MM/yyyy').format(dataEntrega);
//     imagemCentralNotifier = ValueNotifier(widget.produto.imagemPrincipal);
//   }

//   void atualizarImagemCentral(String novaImagem) {
//     if (imagemCentralNotifier.value != novaImagem) {
//       imagemCentralNotifier.value = novaImagem;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final produtosController = Provider.of<ProdutosController>(context);
//     final calcularFrete = Provider.of<CalcularFreteController>(context);
//     return Scaffold(
//       backgroundColor: Themes.colorBackground,
//       appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(140), child: AppBarWidget()),
//       body: Center(
//         child: ConstrainedBox(
//           constraints: const BoxConstraints(maxWidth: 1200),
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(20),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Themes.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Themes.blackShadow,
//                     blurRadius: 12,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           child: MouseRegion(
//                             onExit: (event) => atualizarImagemCentral(
//                                 widget.produto.imagemPrincipal),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 MouseRegion(
//                                   onEnter: (_) => atualizarImagemCentral(
//                                       widget.produto.imagemPrincipal),
//                                   child: CardImageProdutoWidget(
//                                     imagemUrl: widget.produto.imagemPrincipal,
//                                   ),
//                                 ),
//                                 MouseRegion(
//                                   onEnter: (_) => atualizarImagemCentral(
//                                       widget.produto.imagem2 ??
//                                           widget.produto.imagemPrincipal),
//                                   child: CardImageProdutoWidget(
//                                     imagemUrl: widget.produto.imagem2 != null
//                                         ? widget.produto.imagem2!
//                                         : widget.produto.imagemPrincipal,
//                                   ),
//                                 ),
//                                 MouseRegion(
//                                   onEnter: (_) => atualizarImagemCentral(
//                                       widget.produto.imagem3 ??
//                                           widget.produto.imagemPrincipal),
//                                   child: CardImageProdutoWidget(
//                                     imagemUrl: widget.produto.imagem3 != null
//                                         ? widget.produto.imagem3!
//                                         : widget.produto.imagemPrincipal,
//                                   ),
//                                 ),
//                                 MouseRegion(
//                                   onEnter: (_) => atualizarImagemCentral(
//                                       widget.produto.imagem4 ??
//                                           widget.produto.imagemPrincipal),
//                                   child: CardImageProdutoWidget(
//                                     fit: BoxFit.cover,
//                                     padding: 0.0,
//                                     imagemUrl: widget.produto.imagem4 != null
//                                         ? widget.produto.imagem4!
//                                         : widget.produto.imagemPrincipal,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),

//                         if (widget.produto.imagemPrincipal.isNotEmpty)
//                           Column(
//                             children: [
//                               ValueListenableBuilder(
//                                   valueListenable: imagemCentralNotifier,
//                                   builder: (context, imagem, _) {
//                                     return AnimatedSwitcher(
//                                       duration:
//                                           const Duration(milliseconds: 500),
//                                       child: CardImageProdutoWidget(
//                                         key: ValueKey(
//                                             '${imagem}_${DateTime.now().millisecondsSinceEpoch}'),
//                                         imagemUrl: imagem,
//                                         width: 500,
//                                         height: 500,
//                                       ),
//                                     );
//                                   }),
//                               CustomTextRich(
//                                 textPrimary: 'Código do produto:',
//                                 fontSizePrimary: 8,
//                                 colorTextPrimary: Colors.black,
//                                 textSecondary: '12345678',
//                                 fontSizeSecondary: 8,
//                                 isBoldSecondary: true,
//                               ),
//                             ],
//                           ),
//                         //Spacer(),
//                         const SizedBox(width: 20),
//                         Flexible(
//                           flex: 2,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             // mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Text(
//                                 widget.produto.nome,
//                                 textAlign: TextAlign.center,
//                                 style: const TextStyle(
//                                   fontSize: 35,
//                                   fontWeight: FontWeight.bold,
//                                   fontFamily: 'Roboto',
//                                   color: Colors.black87,
//                                 ),
//                               ),
//                               const SizedBox(height: 6),
//                               CustomTextRich(
//                                 textPrimary: 'Descrição:',
//                                 fontSizePrimary: 14,
//                                 colorTextPrimary: Colors.black,
//                                 textSecondary: widget.produto.descricao,
//                                 fontSizeSecondary: 16,
//                                 isBoldSecondary: true,
//                               ),
//                               const SizedBox(height: 6),
//                               CustomTextRich(
//                                 textPrimary: 'Categoria:',
//                                 fontSizePrimary: 14,
//                                 colorTextPrimary: Colors.black,
//                                 textSecondary: 'Utensílios',
//                                 fontSizeSecondary: 16,
//                                 isBoldSecondary: true,
//                               ),
//                               CustomTextRich(
//                                   textPrimary: 'Material:',
//                                   fontSizePrimary: 14,
//                                   colorTextPrimary: Colors.black,
//                                   textSecondary: widget.produto.material,
//                                   fontSizeSecondary: 16,
//                                   isBoldSecondary: true),

//                               CustomTextRich(
//                                 textPrimary: 'Dimensões:',
//                                 fontSizePrimary: 14,
//                                 colorTextPrimary: Colors.black,
//                                 textSecondary: widget.produto.dimensoes,
//                                 fontSizeSecondary: 16,
//                                 isBoldSecondary: true,
//                               ),
//                               //Text('Material: ${produto.material}'),
//                               //Text('Dimensões: ${produto.dimensoes}'),
//                               CustomTextRich(
//                                 textPrimary: 'Peso:',
//                                 fontSizePrimary: 14,
//                                 colorTextPrimary: Colors.black,
//                                 textSecondary: widget.produto.peso,
//                                 fontSizeSecondary: 16,
//                                 isBoldSecondary: true,
//                               ),
//                               const SizedBox(height: 12),
//                               Center(
//                                 child: ContadorQuantidade(),
//                               ),
//                               const SizedBox(height: 12),
//                               Center(
//                                 child: Animate(
//                                   effects: [
//                                     FadeEffect(duration: 400.ms, delay: 350.ms),
//                                     SlideEffect(
//                                         duration: 400.ms,
//                                         begin: Offset(0, 0.2)),
//                                   ],
//                                   child: CustomTextRich(
//                                     textPrimary: 'R\$',
//                                     fontSizePrimary: 18,
//                                     colorTextPrimary: Themes.redPrimary,
//                                     textSecondary: Formatters.formatercurrency(
//                                         widget.produto.valorNoPix
//                                             .toStringAsFixed(2)),
//                                     fontSizeSecondary: 40,
//                                     colorTextSecondary: Themes.redPrimary,
//                                     isBoldSecondary: true,
//                                     textTertiary: '(no pix)',
//                                     fontSizeTertiary: 14,
//                                     colorTextTertiary: Themes.green,
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     CustomTextRich(
//                                       textPrimary: 'ou em até',
//                                       textSecondary: '12x',
//                                       fontSizePrimary: 14,
//                                       colorTextSecondary: Themes.redPrimary,
//                                       fontSizeSecondary: 18,
//                                     ),
//                                     const SizedBox(width: 4),
//                                     CustomTextRich(
//                                       textPrimary: 'de',
//                                       fontSizePrimary: 14,
//                                       textSecondary:
//                                           'R\$ ${(widget.produto.valorVenda / 12).toStringAsFixed(2)}',
//                                       colorTextSecondary: Themes.redPrimary,
//                                       fontSizeSecondary: 18,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               !widget.produto.freteGratis
//                                   ? Center(
//                                       child: CalculaFreteWidget(
//                                         onCalcularFrete: (cep) async {
//                                           final result = await calcularFrete
//                                               .calcularFrete(
//                                                   cepDestino: cep,
//                                                   products: [
//                                                 {
//                                                   'id': widget.produto.id,
//                                                   'width': 23,
//                                                   'height': 12,
//                                                   'length': 11,
//                                                   'weight': 1.2,
//                                                 }
//                                               ]);
//                                           final extrairValores = calcularFrete
//                                               .extrairValoresServicos(result);
//                                           // print(
//                                           //     'Resultado do frete: $result');
//                                           return extrairValores;
//                                         },
//                                       ),
//                                     )
//                                   : Column(
//                                       children: [
//                                         Text(
//                                           'Frete Grátis',
//                                           style: TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.bold,
//                                               color: Themes.green),
//                                         ),
//                                         Text(
//                                             Formatters.dataEntregaFormatada(12))
//                                       ],
//                                     ),
//                               Center(
//                                 child: CustomButton(
//                                   onPressed: () {},
//                                   width: 200,
//                                   height: 50,
//                                   backgroundColor: Colors.green,
//                                   foregroundColor: Colors.white,
//                                   borderRadius: 12,
//                                   elevation: 2,
//                                   child: Text('Adicionar ao Carrinho'),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Center(
//                       child: Text(
//                         'Informações do Produto',
//                         style: TextStyle(
//                             fontSize: 32,
//                             fontWeight: FontWeight.bold,
//                             color: Themes.redPrimary),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Sobre o produto:',
//                             style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Themes.redPrimary),
//                           ),
//                           widget.produto.sobre != null
//                               ? Text(
//                                   widget.produto.sobre!,
//                                   style: GoogleFonts.robotoCondensed(
//                                     fontSize: 16,
//                                     color: Colors.black87,
//                                   ),
//                                 )
//                               : const Text(
//                                   'Nenhuma informação adicional disponível.',
//                                   style: TextStyle(
//                                       fontSize: 16, fontFamily: 'Roboto'),
//                                 ),
//                           const SizedBox(height: 20),
//                           Text(
//                             'Caracteristicas:',
//                             style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Themes.redPrimary),
//                           ),
//                           if (widget.produto.peso != null)
//                             CustomTextRich(
//                               textPrimary: 'Peso:',
//                               fontSizePrimary: 14,
//                               colorTextPrimary: Colors.black,
//                               textSecondary: widget.produto.peso!,
//                               fontSizeSecondary: 16,
//                               isBoldSecondary: true,
//                               textTertiary: '(aproximadamente)',
//                               fontSizeTertiary: 12,
//                             ),
//                           if (widget.produto.dimensoes != null)
//                             CustomTextRich(
//                                 textPrimary: 'Dimensões:',
//                                 fontSizePrimary: 14,
//                                 colorTextPrimary: Colors.black,
//                                 textSecondary: widget.produto.dimensoes!,
//                                 fontSizeSecondary: 16,
//                                 isBoldSecondary: true),
//                           if (widget.produto.material != null)
//                             CustomTextRich(
//                                 textPrimary: 'Material:',
//                                 fontSizePrimary: 14,
//                                 colorTextPrimary: Colors.black,
//                                 textSecondary: widget.produto.material!,
//                                 fontSizeSecondary: 16,
//                                 isBoldSecondary: true),
//                           if (widget.produto.marca != null)
//                             CustomTextRich(
//                                 textPrimary: 'Marca:',
//                                 fontSizePrimary: 14,
//                                 colorTextPrimary: Colors.black,
//                                 textSecondary: widget.produto.marca!,
//                                 fontSizeSecondary: 16,
//                                 isBoldSecondary: true),
//                           if (widget.produto.cor != null)
//                             CustomTextRich(
//                                 textPrimary: 'Cor:',
//                                 fontSizePrimary: 14,
//                                 colorTextPrimary: Colors.black,
//                                 textSecondary: widget.produto.cor!,
//                                 fontSizeSecondary: 16,
//                                 isBoldSecondary: true),
//                           if (widget.produto.consumoEletrico != null)
//                             CustomTextRich(
//                                 textPrimary: 'Consumo Elétrico:',
//                                 fontSizePrimary: 14,
//                                 colorTextPrimary: Colors.black,
//                                 textSecondary: widget.produto.consumoEletrico!,
//                                 fontSizeSecondary: 16,
//                                 isBoldSecondary: true),
//                           const SizedBox(height: 20),
//                           Text(
//                             'Recomendações de uso:',
//                             style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Themes.redPrimary),
//                           ),
//                           Text(
//                             widget.produto.sugestoesDeUso ??
//                                 'Nenhuma sugestão de uso disponível.',
//                             style: const TextStyle(
//                                 fontSize: 16, fontFamily: 'Roboto'),
//                           ),
//                           const SizedBox(height: 20),
//                         ],
//                       ),
//                     ),
//                     FutureBuilder(
//                         future: produtosController.buscarProdutos(),
//                         builder: (context, snapshot) {
//                           final produtos = snapshot.data;
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return const Center(
//                                 child: CircularProgressIndicator());
//                           } else if (snapshot.hasError) {
//                             return Text('Erro: ${snapshot.error}');
//                           } else {
//                             return Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 16),
//                               child: Wrap(
//                                 spacing: 16,
//                                 runSpacing: 16,
//                                 children:
//                                     produtos != null && produtos.isNotEmpty
//                                         ? produtos.map((produto) {
//                                             return CardProduto(
//                                               produto: produto,
//                                               onTap: () {
//                                                 Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         ProdutoDetalheScreen(
//                                                             produto: produto),
//                                                   ),
//                                                 );
//                                                 //abrirTelaCheckout(context, produto);
//                                               },
//                                             );
//                                           }).toList()
//                                         : [
//                                             const Text(
//                                               'Nenhum produto encontrado.',
//                                               style: TextStyle(
//                                                 fontSize: 16,
//                                                 fontFamily: 'Roboto',
//                                                 color: Colors.black54,
//                                               ),
//                                             ),
//                                           ],
//                               ),
//                             );
//                           }
//                         }),
//                     FooterWidget()
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CardImageProdutoWidget extends StatelessWidget {
//   final String imagemUrl;
//   final double? width;
//   final double? height;
//   final double? widtthImage;
//   final double? heightImage;
//   final BoxFit? fit;
//   final double? padding;

//   /// Widget para exibir a imagem do produto em um card.
//   /// Aceita [imagemUrl] como URL da imagem, [width] e [height] para definir o tamanho do card.
//   /// Se a imagem não estiver disponível, exibe um ícone de imagem não suportada

//   const CardImageProdutoWidget(
//       {this.height,
//       this.width,
//       required this.imagemUrl,
//       this.widtthImage,
//       this.heightImage,
//       this.fit,
//       this.padding,
//       super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: width ?? 120,
//       height: height ?? 120,
//       decoration: BoxDecoration(
//         //color: Colors.amber,
//         border: Border.all(
//           color: Colors.black26,
//           width: 1,
//         ),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       margin: const EdgeInsets.only(bottom: 12),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: imagemUrl.isNotEmpty
//             ? Padding(
//                 padding: EdgeInsets.all(padding ?? 8.0),
//                 child: Image.network(
//                   width: widtthImage ?? 70,
//                   height: heightImage ?? 70,
//                   imagemUrl,
//                   fit: fit ?? BoxFit.contain,
//                   filterQuality: FilterQuality.high,
//                 ),
//               )
//             : const Icon(Icons.image_not_supported,
//                 size: 48, color: Colors.grey),
//       ),
//     );
//   }
// }
