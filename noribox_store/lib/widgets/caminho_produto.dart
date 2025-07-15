import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CaminhoProduto extends StatelessWidget {
  final String nomeProduto;
  const CaminhoProduto({required this.nomeProduto, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Home / Produtos / $nomeProduto',
          style: GoogleFonts.roboto(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}
