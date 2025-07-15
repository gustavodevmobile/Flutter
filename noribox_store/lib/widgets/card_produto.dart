import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noribox_store/models/produtos_models.dart';
import 'package:noribox_store/themes/themes.dart';
import 'package:noribox_store/utils/formatters.dart';
import 'package:noribox_store/widgets/card_image_products.dart';
import 'package:noribox_store/widgets/contador_quantidade.dart';
import 'package:noribox_store/widgets/custom_button.dart';
import 'package:noribox_store/widgets/custom_text_rich.dart';

class CardProduto extends StatefulWidget {
  final Produto produto;
  final VoidCallback? onTap;

  const CardProduto({
    super.key,
    required this.produto,
    this.onTap,
  });

  @override
  State<CardProduto> createState() => _CardProdutoState();
}

class _CardProdutoState extends State<CardProduto> {
  bool hovering = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: AnimatedScale(
        scale: hovering ? 1.08 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width: 200,
            //height: 350,
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
                if (hovering)
                  const BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 8),
                    blurRadius: 32,
                    spreadRadius: 2,
                  ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Imagem do produto
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: widget.produto.imagemPrincipal.isNotEmpty
                      ? CardImageProdutoWidget(
                          imagemUrl: widget.produto.imagemPrincipal,
                          width: 180,
                          height: 200,
                          fit: BoxFit.contain)
                      : Container(
                          width: 80,
                          height: 80,
                          color: Colors.white,
                          child: const Icon(Icons.shopping_bag,
                              size: 48, color: Colors.grey),
                        ),
                ),
                // Nome do produto
                const SizedBox(height: 4),
                Text(
                  widget.produto.nome,
                  style: GoogleFonts.aboreto(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                //const SizedBox(height: 4),
                Text(
                  widget.produto.descricao,
                  style: GoogleFonts.aboreto(
                    fontSize: 10,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                // Preço
                const SizedBox(height: 4),
                // Estrelas de avaliação
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return Icon(Icons.star, color: Colors.amber, size: 20);
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
                    textSecondary: Formatters.formatercurrency(
                        widget.produto.valorNoPix.toStringAsFixed(2)),
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
                    textQuinary:
                        (widget.produto.valorVenda / 12).toStringAsFixed(2),
                    fontSizeQuinary: 14,
                    colorTextQuinary: Themes.redPrimary,
                    isBoldQuinary: true,
                  ),
                ),
                const SizedBox(height: 12),
                ContadorQuantidade(),
                const SizedBox(height: 8),
                CustomButton(
                  onPressed: () {},
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  borderRadius: 12,
                  elevation: 2,
                  child: Text('Adicionar ao Cariinho'),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 300.ms).then().moveY(duration: 300.ms),
      ),
    );
  }
}
