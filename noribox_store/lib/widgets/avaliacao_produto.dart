import 'package:flutter/material.dart';

class AvaliacoesProdutoWidget extends StatelessWidget {
  final double notaMedia;
  final int quantidadeAvaliacoes;

  const AvaliacoesProdutoWidget({
    super.key,
    required this.notaMedia,
    required this.quantidadeAvaliacoes,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Estrelas
        Row(
          children: List.generate(5, (index) {
            return Icon(
              index < notaMedia.round()
                  ? Icons.star
                  : Icons.star_border,
              color: Colors.amber,
              size: 20,
            );
          }),
        ),
        const SizedBox(width: 8),
        // Nota média
        Text(
          notaMedia.toStringAsFixed(1),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 4),
        // Quantidade de avaliações
        Text(
          '($quantidadeAvaliacoes avaliações)',
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}