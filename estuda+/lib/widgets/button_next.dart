import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonNext extends StatelessWidget {
  final String textContent;
  final double? height;
  final Color? primary;
  final Color? secundary;
  final Color? terciary;
  final double? fontSize;
  const ButtonNext(
      {required this.textContent,
      this.height = 50,
      this.primary,
      this.secundary,
      this.terciary,
      this.fontSize = 20,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              primary ?? Colors.white70,
              secundary ?? Colors.white,
              terciary ?? Colors.white70,
            ],
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              spreadRadius: 1,
              blurRadius: 2,
            ),
          ],
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            textContent,
            style: GoogleFonts.aboreto(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
