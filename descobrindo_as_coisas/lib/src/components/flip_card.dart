import 'dart:async';
import 'dart:math';
import 'package:descobrindo_as_coisas/src/components/dialog.dart';
import 'package:descobrindo_as_coisas/src/controller/controller.dart';
import 'package:descobrindo_as_coisas/src/controller/counter.dart';
import 'package:descobrindo_as_coisas/src/controller/states.dart';
import 'package:descobrindo_as_coisas/src/screens/memory_play/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class FlipCard extends StatefulWidget {
  final Widget frontCard;
  final Widget backCard;
  final String contentCard;
  bool isMatch;

  FlipCard({
    required this.frontCard,
    required this.backCard,
    required this.contentCard,
    this.isMatch = false,
    super.key,
  });

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool isFlipped = true;
  //static List<String> comparison = [];
  //static List<String> identifyLetter = [];

  Counter counter = Counter();
  States states = States();
  Controller controller = Controller();
  Timer? _timer;

  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: pi,
    ).animate(_controller);

    _controller.addListener(() {
      if (_controller.value >= 0.5 && states.isFlipped) {
        setState(() {
          states.isFlipped = false;
        });
      } else if (_controller.value < 0.5 && !states.isFlipped) {
        setState(() {
          states.isFlipped = true;
        });
      }
    });
    _controller.forward();
    Future.delayed(Duration(seconds: 10)).then((t) {
      _controller.reverse();
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  controllerCard() {
    
    // so abre 2  cartas por vez
    if (states.isFlipped && Counter.count < 2) {
      // animação para abrir
      _controller.forward();
      // adicionaa primeira letra da primeira sequencia na lista para comparar
      Controller.compare.add(widget.contentCard);
      //contador de comparação
      counter.increment();
      // compara a partir da segunda carta
      if (Counter.count > 1) {
        // se forem iguais:
        if (Controller.compare[0] == Controller.compare[1]) {
          // limpa o contador
          Counter.count = 0;
          // contador de combinações
          counter.counterMatch();

          //delay de 1 segundo para mudar a borda
          _timer = Timer(Duration(seconds: 1), () {
            Provider.of<Controller>(listen: false, context)
                .changeBorderCards(3);
            Provider.of<Controller>(listen: false, context).changeBorder(true);
          });

          //atribui à segunda carta aberta como true para imobiliza-la

          states.isMatch = true;
          // remove da lista as letras comparadas
          Controller.compare.removeWhere((el) => el == widget.contentCard);
          // adiciona a segunda letra para na lista para poder imobiliza-la a primeira letra escolhida.
          Controller.identifyLetter.add(widget.contentCard);
          // verifica se o jogador encontrou todas as combinações
          if (Counter.matchs == Helpers.letter.length / 2) {
            _timer = Timer(Duration(seconds: 2), () {
              showDialogFeedBack(context);
            });
            Provider.of<Controller>(listen: false, context).timerActivity(true);
          }
        } else {
          // se nao for igual, não imobiliza
          states.isMatch = false;
        }
      }
    } else if (states.isMatch) {
      // imobiliza a segunda carta aberta
      _controller.stop();
      // se tiver menos de 2 no contador ou seja, 2 cartas abertas, permite que desvire se:
    } else if (Counter.count <= 2 && !states.isFlipped) {
      // se tiver a letra na identifyList
      if (Controller.identifyLetter.contains(widget.contentCard)) {
        // imobiliza a segunda carta aberta
        _controller.stop();
      } else {
        // se não, permite que desvire
        _controller.reverse();
        // tira a letra desvirada da lista
        Controller.compare.removeWhere((el) => el == widget.contentCard);
        // conta -1 no contador
        counter.decrement();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Controller>(
      builder: (context, value, child) {
        return GestureDetector(
          onTap: () {
            setState(() {
              controllerCard();
            });
          },
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0012)
                  ..rotateY(_animation.value),
                child: child,
              );
            },
            child: states.isFlipped
                ? widget.frontCard
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.0012)
                      ..rotateY(pi),
                    child: widget.backCard,
                  ),
          ),
        );
      },
    );
  }
}

// class BackCard extends StatefulWidget {
//   final String letter;
//   final Color borderColor;
//   double widthBorder;

//   BackCard({
//     required this.letter,
//     this.borderColor = Colors.white,
//     this.widthBorder = 3,
//     super.key,
//   });

//   @override
//   State<BackCard> createState() => _BackCardState();
// }

// class _BackCardState extends State<BackCard> {
//   double widthBorder2 = 3;

//   controllerBorder() {
//     widget.widthBorder = 0;
//     print('e ai');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ControllerAccept>(builder: (context, value, child) {
//       return Container(
//         width: 70,
//         height: 70,
//         decoration: BoxDecoration(
//           color: Colors.blue,
//           borderRadius: BorderRadius.circular(10),
//           border:
//               Border.all(width: widget.widthBorder, color: widget.borderColor),
//         ),
//         child: Center(
//           child: Text(
//             widget.letter,
//             style: TextStyle(
//               fontSize: 35,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }
