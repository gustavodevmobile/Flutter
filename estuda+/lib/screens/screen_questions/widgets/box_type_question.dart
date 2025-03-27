import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BoxTypeQuestion extends StatelessWidget {
  final String elemetarySchool;
  final String series;
  final String displice;
  final String subject;
  const BoxTypeQuestion(
      this.elemetarySchool, this.displice, this.series, this.subject,
      {super.key});

  final double font = 14;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: 'Ensino ',
              style: GoogleFonts.aboreto(
                  fontSize: 10,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: elemetarySchool,
                  style: GoogleFonts.aboreto(
                      fontSize: font,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: 'Ano: ',
              style: GoogleFonts.aboreto(
                  fontSize: 10,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: series,
                  style: GoogleFonts.aboreto(
                      fontSize: font,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: 'Disciplina: ',
              style: GoogleFonts.aboreto(
                  fontSize: 10,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: displice,
                  style: GoogleFonts.aboreto(
                      fontSize: font,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: 'Assunto: ',
              style: GoogleFonts.aboreto(
                  fontSize: 10,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: subject,
                  style: GoogleFonts.aboreto(
                      fontSize: font,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
