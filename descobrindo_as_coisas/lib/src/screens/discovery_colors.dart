import 'dart:math';

import 'package:descobrindo_as_coisas/src/components/backgroud.dart';
import 'package:descobrindo_as_coisas/src/components/draggables.dart';
import 'package:descobrindo_as_coisas/src/components/dragtarget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class DiscoveryColors extends StatefulWidget {
  const DiscoveryColors({super.key});

  @override
  State<DiscoveryColors> createState() => _DiscoveryColorsState();
}

class _DiscoveryColorsState extends State<DiscoveryColors> {
  FlutterTts flutterTts = FlutterTts();
  String text = 'Junte a cor com a palavra correspondente;';
  @override
  void initState() {
    super.initState();
    //voice(text);
  }

  Future voice(String text) async {
    await flutterTts.setLanguage('pt-BR');
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

//   generatorDoublesY({required double start, required double end}) {
//     double valueYPosition = 0;
//     valueYPosition = Random().nextDouble() * (end - start) + start;
//     String stringGenerator = valueYPosition.toStringAsFixed(1);
//     valueYPosition = double.parse(stringGenerator);
//     //print('y1 $valueYPosition');
//     return valueYPosition;
//   }

// // eixo x start 3 end 230
//   generatorDoublesX({required double start, required double end}) {
//     double valueXPosition = 0;
//     valueXPosition = Random().nextDouble() * (end - start) + start;
//     String stringGenerator = valueXPosition.toStringAsFixed(1);
//     valueXPosition = double.parse(stringGenerator);
//     //print('x1 $valueXPosition');
//     return valueXPosition;
//   }

  @override
  Widget build(BuildContext context) {
    double column1Target = 15;
    //generatorDoublesX(start: 10, end: 30);
    double column2Target = 125;
    //generatorDoublesX(start: 130, end: 150);
    double column3Target = 235;
    //generatorDoublesX(start: 240, end: 250);
    double row1Target = 15;
    //generatorDoublesY(start: 10, end: 30);
    double row2Target = 67;
    //generatorDoublesY(start: 75, end: 85);
    double row3Target = 120;
    //generatorDoublesY(start: 135, end: 145);
    double row4Target = 173;
    //generatorDoublesY(start: 195, end: 205);
    double row5Target = 225;

    double column1 = 15;
    //generatorDoublesX(start: 15, end: 40);
    double column2 = 125;
    //generatorDoublesX(start: 125, end: 160);
    double column3 = 235;
    //generatorDoublesX(start: 235, end: 260);
    double row1 = 290;
    //generatorDoublesY(start: 250, end: 260);
    double row2 = 350;
    //generatorDoublesY(start: 320, end: 330);
    double row3 = 410;
    //generatorDoublesY(start: 390, end: 400);
    double row4 = 470;
    //generatorDoublesY(start: 460, end: 470);
    double row5 = 530;

    // coluna 1
    Offset positionXyR1C1Target = Offset(column1Target, row1Target);
    Offset positionXyR2C1Target = Offset(column1Target, row2Target);
    Offset positionXyR3C1Target = Offset(column1Target, row3Target);
    Offset positionXyR4C1Target = Offset(column1Target, row4Target);
    Offset positionXyR5C1Target = Offset(column1Target, row5Target);

    // coluna 2
    Offset positionXyR1C2Target = Offset(column2Target, row1Target);
    Offset positionXyR2C2Target = Offset(column2Target, row2Target);
    Offset positionXyR3C2Target = Offset(column2Target, row3Target);
    Offset positionXyR4C2Target = Offset(column2Target, row4Target);
    Offset positionXyR5C2Target = Offset(column2Target, row5Target);

    //coluna 3
    Offset positionXyR1C3Target = Offset(column3Target, row1Target);
    Offset positionXyR2C3Target = Offset(column3Target, row2Target);
    Offset positionXyR3C3Target = Offset(column3Target, row3Target);
    Offset positionXyR4C3Target = Offset(column3Target, row4Target);
    Offset positionXyR5C3Target = Offset(column3Target, row5Target);

    Offset positionXyR5C1 = Offset(column1, row1);
    Offset positionXyR6C1 = Offset(column1, row2);
    Offset positionXyR7C1 = Offset(column1, row3);
    Offset positionXyR8C1 = Offset(column1, row4);
    Offset positionXyR9C1 = Offset(column1, row5);

    Offset positionXyR5C2 = Offset(column2, row1);
    Offset positionXyR6C2 = Offset(column2, row2);
    Offset positionXyR7C2 = Offset(column2, row3);
    Offset positionXyR8C2 = Offset(column2, row4);
    Offset positionXyR9C2 = Offset(column2, row5);

    Offset positionXyR5C3 = Offset(column3, row1);
    Offset positionXyR6C3 = Offset(column3, row2);
    Offset positionXyR7C3 = Offset(column3, row3);
    Offset positionXyR8C3 = Offset(column3, row4);
    Offset positionXyR9C3 = Offset(column3, row5);

    List<Offset> positions = [
      positionXyR1C1Target,
      positionXyR1C2Target,
      positionXyR1C3Target,
      positionXyR2C1Target,
      positionXyR2C2Target,
      positionXyR2C3Target,
      positionXyR3C1Target,
      positionXyR3C2Target,
      positionXyR3C3Target,
      positionXyR4C1Target,
      positionXyR4C2Target,
      positionXyR4C3Target,
      positionXyR5C1Target,
      positionXyR5C2Target,
      positionXyR5C3Target,
      positionXyR5C1,
      positionXyR5C2,
      positionXyR5C3,
      positionXyR6C1,
      positionXyR6C2,
      positionXyR6C3,
      positionXyR7C1,
      positionXyR7C2,
      positionXyR7C3,
      positionXyR8C1,
      positionXyR8C2,
      positionXyR8C3,
      positionXyR9C1,
      positionXyR9C2,
      positionXyR9C3
    ];

    Widget shuffle() {
      positions.shuffle();
      return Stack(
        children: [
          Draggables(
              position: positions[0],
              //positionXyR5C2,
              backgroundColor: Colors.orange),
          Draggables(
            position: positions[1],
            //positionXyR5C1,
            backgroundColor: Colors.green,
          ),
          Draggables(
            position: positions[2],
            backgroundColor: Colors.blue,
          ),
          Draggables(
            position: positions[3],
            backgroundColor: Colors.red,
          ),
          Draggables(
            position: positions[4],
            backgroundColor: Colors.yellow,
          ),
          Draggables(
            position: positions[5],
            backgroundColor: Colors.brown,
          ),
          Draggables(
            position: positions[6],
            backgroundColor: Colors.purple,
          ),
          Draggables(
            position: positions[7],
            backgroundColor: Colors.pink,
          ),
          Draggables(
            position: positions[8],
            backgroundColor: Colors.grey,
          ),
          Draggables(
            position: positions[9],
            backgroundColor: Colors.black,
          ),
          Draggables(
            position: positions[10],
            backgroundColor: Colors.white,
            textColor: Colors.black,
          ),
          Draggables(
            position: positions[11],
            backgroundColor: Colors.greenAccent,
          ),
          Draggables(
            position: positions[12],
            backgroundColor: Colors.indigo,
          ),
          Draggables(
            position: positions[13],
            backgroundColor: const Color.fromARGB(255, 34, 75, 35),
          ),
          Draggables(
            position: positions[14],
            backgroundColor: const Color.fromARGB(255, 26, 175, 245),
          ),
          Dragtargets(
            position: positions[15],
            textContent: 'Azul Claro',
            backgroundColor: const Color.fromARGB(255, 26, 175, 245),
            textColor: Colors.greenAccent,
          ),
          Dragtargets(
            position: positions[16],
            textContent: 'Verde Escuro',
            backgroundColor: const Color.fromARGB(255, 34, 75, 35),
            textColor: Colors.pink,
          ),
          Dragtargets(
            position: positions[17],
            textContent: 'Azul Escuro',
            backgroundColor: Colors.indigo,
            textColor: Colors.green,
          ),
          Dragtargets(
            position: positions[18],
            textContent: 'Verde Claro',
            backgroundColor: Colors.greenAccent,
            textColor: Colors.indigo,
          ),
          Dragtargets(
            position: positions[19],
            textContent: 'Branco',
            backgroundColor: Colors.white,
            textColor: Colors.indigo,
          ),
          Dragtargets(
            position: positions[20],
            textContent: 'Preto',
            backgroundColor: Colors.black,
            textColor: Colors.red,
          ),
          Dragtargets(
            position: positions[21],
            textContent: 'Cinza',
            backgroundColor: Colors.grey,
            textColor: Colors.purple,
          ),
          Dragtargets(
            position: positions[22],
            textContent: 'Rosa',
            backgroundColor: Colors.pink,
            textColor: Colors.indigo,
          ),
          Dragtargets(
            position: positions[23],
            textContent: 'Violeta',
            backgroundColor: Colors.purple,
            textColor: Colors.pink,
          ),
          Dragtargets(
            position: positions[24],
            textContent: 'Marrom',
            backgroundColor: Colors.brown,
            textColor: Colors.teal,
          ),
          Dragtargets(
            position: positions[25],
            textContent: 'Laranja',
            backgroundColor: Colors.orange,
            textColor: Colors.brown,
          ),
          Dragtargets(
            position: positions[26],
            textContent: 'Verde',
            backgroundColor: Colors.green,
            textColor: Colors.red,
          ),
          Dragtargets(
            position: positions[27],
            textContent: 'Azul',
            backgroundColor: Colors.blue,
            textColor: Colors.yellow,
          ),
          Dragtargets(
            position: positions[28],
            textContent: 'Vermelho',
            backgroundColor: Colors.red,
            textColor: Colors.blue,
          ),
          Dragtargets(
            position: positions[29],
            textContent: 'Amarelo',
            backgroundColor: Colors.yellow,
            textColor: Colors.black,
          ),
        ],
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Palavras e Cores'),
          backgroundColor: Colors.indigoAccent,
          actions: [
            IconButton(
                onPressed: () {
                  //Navigator.popAndPushNamed(context, 'colorAndWord');
                  setState(() {});
                },
                icon: Icon(Icons.refresh))
          ],
        ),
        body: Backgroud(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white60,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Junte a cor com a palavra correspondente;',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            height: 600,
                            decoration: BoxDecoration(border: Border.all()),
                            child: shuffle()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
