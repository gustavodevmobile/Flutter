import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noribox_store/models/produtos_models.dart';
import 'package:noribox_store/themes/themes.dart';
import 'package:noribox_store/utils/formatters.dart';
import 'package:noribox_store/widgets/contador_quantidade.dart';
import 'package:noribox_store/widgets/custom_text_rich.dart';

class CardProduto extends StatelessWidget {
  final Produto produto;
  final VoidCallback? onTap;

  const CardProduto({
    super.key,
    required this.produto,
    this.onTap,
  });

  Widget _buildBase64Image(String base64String,
      {double? height, double? width, BoxFit? fit}) {
    try {
      Uint8List bytes = base64Decode(base64String);
      return Image.memory(
        bytes,
        height: height,
        width: width,
        fit: fit,
      );
    } catch (e) {
      return const Icon(Icons.broken_image, color: Colors.grey, size: 48);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            // Sombra clara no topo/esquerda
            BoxShadow(
              color: Colors.grey.shade400,
              offset: const Offset(4, 4),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Imagem do produto
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: produto.imagemPrincipal.isNotEmpty
                    ? _buildBase64Image(
                        produto.imagemPrincipal,
                        // width: 200,
                        // height: 200,
                        fit: BoxFit.contain,
                      )
                    : Container(
                        width: 80,
                        height: 80,
                        color: Colors.white,
                        child: const Icon(Icons.shopping_bag,
                            size: 48, color: Colors.grey),
                      ),
              ),
            ),
            const SizedBox(height: 8),

            // Nome do produto
            const SizedBox(height: 4),
            Text(
              produto.nome,
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            // const SizedBox(height: 4),
            SizedBox(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  produto.descricao,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            // Preço
            const SizedBox(height: 4),
            // Estrelas de avaliação
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Icon(Icons.star, color: Colors.amber, size: 20);
                // Icon(
                //   index < (produto.avaliacao ?? '4') // valor mock ou do produto
                //       ? Icons.star
                //       : Icons.star_border,
                //   color: Colors.amber,
                //   size: 18,
                // );
              }),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: CustomTextRich(
                textPrimary: 'R\$',
                fontSizePrimary: 12,
                colorTextPrimary: Themes.redPrimary,
                isBoldPrimary: true,
                textSecondary: Formatters.formatercurrency(produto.valorNoPix.toString()),
                fontSizeSecondary: 26,
                colorTextSecondary: Themes.redPrimary,
                isBoldSecondary: true,
                textTertiary: '(no Pix)',
                fontSizeTertiary: 12,
                colorTextTertiary: Themes.green,
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: CustomTextRich(
                textPrimary: ' ou em até',
                fontSizePrimary: 12,
                colorTextPrimary: Themes.blackLight,
                textSecondary: '12x',
                fontSizeSecondary: 14,
                colorTextSecondary: Themes.redPrimary,
                isBoldSecondary: true,
                textTertiary: 'de',
                fontSizeTertiary: 12,
                colorTextTertiary: Themes.blackLight,
                textQuaternary: 'R\$',
                fontSizeQuaternary: 12,
                colorTextQuaternary: Themes.redPrimary,
                isBoldQuaternary: true,
                textQuinary: (produto.valorVenda / 12).toString(),
                fontSizeQuinary: 14,
                colorTextQuinary: Themes.redPrimary,
                isBoldQuinary: true,
              ),
            ),
            const SizedBox(height: 12),
            // Botão comprar
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 12),
            //   child: Row(
            //     children: [
            //       //ContadorQuantidade(),
            //       const SizedBox(width: 8),
            //       Expanded(
            //         child: ElevatedButton(
            //           onPressed: onTap,
            //           style: ElevatedButton.styleFrom(
            //             backgroundColor: Colors.green,
            //             foregroundColor: Colors.white,
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(8),
            //             ),
            //             padding: const EdgeInsets.symmetric(vertical: 10),
            //             textStyle: const TextStyle(
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //           child: const Text('Comprar'),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(height: 8),

            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: SizedBox(
            //     width: double.infinity,
            //     child: ElevatedButton(
            //       onPressed: onTap,
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.lightGreen,
            //         foregroundColor: Colors.white,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(8),
            //         ),
            //         //padding: const EdgeInsets.symmetric(vertical: 10),
            //         textStyle: const TextStyle(
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //       child: const Text('Dúvidas'),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).then().moveY(duration: 300.ms);
  }
}
