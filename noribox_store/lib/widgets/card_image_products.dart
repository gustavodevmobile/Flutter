import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CardImageProdutoWidget extends StatelessWidget {
  final String imagemUrl;
  final double? width;
  final double? height;
  final double? widtthImage;
  final double? heightImage;
  final BoxFit? fit;
  final double? padding;
  final bool isBorder;

  /// Widget para exibir a imagem do produto em um card.
  /// Aceita [imagemUrl] como URL da imagem, [width] e [height] para definir o tamanho do card.
  /// Se a imagem não estiver disponível, exibe um ícone de imagem não suportada

  const CardImageProdutoWidget(
      {this.height,
      this.width,
      required this.imagemUrl,
      this.widtthImage,
      this.heightImage,
      this.fit,
      this.padding,
      this.isBorder = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 120,
      height: height ?? 120,
      decoration: BoxDecoration(
        border: isBorder
            ? Border.all(
                color: Colors.black26,
                width: 1,
              )
            : null,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: imagemUrl.isNotEmpty
            ? Padding(
                padding: EdgeInsets.all(padding ?? 8.0),
                child: CachedNetworkImage(
                  imageUrl: imagemUrl,
                  width: widtthImage ?? 220,
                  height: heightImage ?? 240,
                  fit: fit ?? BoxFit.cover,
                  placeholder: (context, url) => ColoredBox(
                    color: Colors.grey.shade200,
                  ).animate().shimmer(duration: 1200.ms),
                  errorWidget: (context, url, error) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.white,
                    child: const Icon(Icons.error, size: 48, color: Colors.red),
                  ),
                ))
            : const Icon(Icons.image_not_supported,
                size: 48, color: Colors.grey),
      ),
    );
  }
}
