import 'package:estudamais/models/models.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AnimatedButtonCircle extends StatefulWidget {
  final String textPrimary;
  final String? textSecondary;
  final double widthButton;
  final double heightButton;
  final double fontSizePrimary;
  final double? fontSizeSecondary;
  final Function onTap;

  const AnimatedButtonCircle(this.textPrimary, this.widthButton,
      this.heightButton, this.fontSizePrimary, this.onTap,
      {this.textSecondary, this.fontSizeSecondary, super.key});

  @override
  State<AnimatedButtonCircle> createState() => _AnimatedButtonCircleState();
}

class _AnimatedButtonCircleState extends State<AnimatedButtonCircle> {
  bool backButton = false;
  Color shadowColor = Colors.black87;
  double shadowBox = 8;

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelPoints>(builder: (context, value, child) {
      return SizedBox(
        width: 115,
        height: 115,
        //color: Colors.black12,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: 0,
              child: Container(
                width: widget.widthButton + 5,
                height: widget.heightButton + 5,
                decoration: BoxDecoration(
                  color: shadowColor,
                  shape: BoxShape.circle,
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 2,
                      spreadRadius: 2,
                    )
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              bottom: shadowBox,
              duration: const Duration(milliseconds: 60),
              child: GestureDetector(
                onTap: () {
                  backButton = !backButton;
                  value.actionBtnCircle = !value.actionBtnCircle;
                  if (backButton) {
                    value.actionBtnCircle = backButton;
                    setState(() {
                      shadowColor = Colors.white;
                      shadowBox = 3;
                    });
                    widget.onTap();
                  } else {
                    print(backButton);
                    value.actionBtnCircle = backButton;
                    setState(() {
                      shadowColor = Colors.black87;
                      shadowBox = 8;
                    });
                    widget.onTap();
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  width: widget.widthButton,
                  height: widget.heightButton,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.indigoAccent,
                        Colors.indigo,
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.textPrimary.substring(0, 2),
                        style: GoogleFonts.aboreto(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.textPrimary.substring(3, 6),
                        style: GoogleFonts.aboreto(
                          fontSize: 20,
                          color: Colors.amber,
                          shadows: [
                            const Shadow(
                              color: Colors.black54,
                              blurRadius: 7,
                              offset: Offset(0.0, 3.0),
                            )
                          ],
                        ),
                      ),
                      //Text(widget.id.toString())
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
