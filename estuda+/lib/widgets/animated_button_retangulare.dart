import 'package:estudamais/providers/global_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimatedButtonRectangular extends StatefulWidget {
  final String title;
  final Function onTap;
  final String? tralling;
  final String? leading;
  final double? fontSizeTitle;
  final MainAxisAlignment? textDirection;

  const AnimatedButtonRectangular(
      {required this.title,
      required this.onTap,
      this.tralling,
      this.leading,
      this.fontSizeTitle = 18.0,
      this.textDirection,
      super.key});

  @override
  State<AnimatedButtonRectangular> createState() =>
      _AnimatedButtonRetangulareState();
}

class _AnimatedButtonRetangulareState extends State<AnimatedButtonRectangular>
    with AutomaticKeepAliveClientMixin {
  double buttonDown = 8;
  Color shadowColor = Colors.black87;
  bool enable = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<GlobalProviders>(builder: (context, value, child) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 60,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                bottom: 0,
                child: Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width - 60,
                  decoration: BoxDecoration(
                    color: shadowColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              AnimatedPositioned(
                bottom: buttonDown,
                duration: const Duration(
                  milliseconds: 60,
                ),
                child: GestureDetector(
                  onTap: () {
                    // valor responsavel pela mudança de estado do botão
                    enable = !enable;
                    //valor responsavel pela consulta por disciplina
                    value.enableBtnRetangulare(enable);
                    setState(() {
                      if (enable) {
                        // posição do botão abaixa em 2
                        buttonDown = 2;
                        // cor da sombra muda pra branco
                        shadowColor = Colors.amber;

                        // chama a função que faz a consulta por disciplica passando value.
                        widget.onTap();
                      } else {
                        // sobe o botão para 8
                        buttonDown = 8;
                        // muda a cor da sombra para preto
                        shadowColor = Colors.black87;

                        // chama a função que faz a remoção da disciplina consultada
                        widget.onTap();
                      }
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: MediaQuery.of(context).size.width - 65,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Colors.indigoAccent,
                          Colors.indigo,
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: widget.textDirection ??
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            widget.title,
                            style: TextStyle(
                                fontSize: widget.fontSizeTitle,
                                color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, right: 15),
                          child: Column(
                            children: [
                              Text(
                                widget.leading ?? '',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                              Text(
                                widget.tralling ?? '',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.amber),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
