import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // importM + tab
import 'package:calculadora/componentes/buttons.dart';
import 'package:flutter/widgets.dart';
import 'package:dart_eval/dart_eval.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String content = '';
  String convertedPorc = '';
  String convertedMult = '';
  String convertedPoint = '';

  void valueBtn(String tecla) {
    setState(() {
      content += tecla;
      convertedPorc = content.replaceAll('%', '/100*');
      convertedMult = content.replaceAll('x', '*');
      convertedPoint = content.replaceAll(',', '.');
      print(content);
    });
  }

  void backSpace() {
    List<String> backSpaceContent = content.split('');
    setState(() {
      if (content == '') {
        valueBtn(content);
      } else {
        backSpaceContent.removeLast();
        content = backSpaceContent.join();
        print(backSpaceContent);
        print(content);
      }
    });
  }

  void calculate() {
    List<String> contentConv = content.split('');
    print(contentConv.last);
    // bool convPorc = contentConv.any((s) => s == '%');
    setState(() {
      bool convPorc = contentConv.any((s) => s == '%');
      if (convPorc) {
        content = convertedPorc;
      }
      bool convMult = contentConv.any((s) => s == 'x');
      if (convMult) {
        content = convertedMult;
      }
      bool convPoint = contentConv.any((s) => s == ',');
      if (convPoint) {
        content = convertedPoint;
      }
      dynamic teste;
      // int testeInt = 7;

      if ((contentConv.last == '+') ||
          (contentConv.last == '-') ||
          (contentConv.last == '*') ||
          (contentConv.last == '/') ||
          (contentConv.last == '%')) {
        contentConv.removeLast();
        content = contentConv.join();
        teste = eval(content);
        content = teste.toString();
      } else {
        teste = eval(content);
        content = teste.toString();
      }
      // List<String> auxTeste = content.split('');
      // print(testeInt);
      // print(auxTeste.last);
    });
  }

  void clear() {
    setState(() {
      content = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Center(
              child: Text(
            'Calculadora',
            style: TextStyle(color: Colors.white),
          )),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 180,
                width: 400,
                alignment: AlignmentDirectional.topEnd,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromRGBO(90, 116, 97, 0.424),
                ),
                child: Text(
                  content,
                  style: const TextStyle(fontSize: 60),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: const Buttons(
                        Color.fromARGB(66, 82, 82, 82), 'C', Colors.red),
                    onTap: () {
                      clear();
                    },
                  ),
                  GestureDetector(
                    child: const BtnDivide(),
                    onTap: () => {valueBtn('/')},
                  ),
                  GestureDetector(
                      child: const Buttons(Color.fromARGB(66, 82, 82, 82), '%',
                          Color.fromARGB(173, 53, 173, 53)),
                      onTap: () => valueBtn('%')),
                  GestureDetector(
                    child: const BackSpace(),
                    onTap: () {
                      backSpace();
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: const Buttons(
                        Color.fromARGB(66, 82, 82, 82), '7', Colors.blue),
                    onTap: () {
                      valueBtn('7');
                    },
                  ),
                  GestureDetector(
                    child: const Buttons(
                        Color.fromARGB(66, 82, 82, 82), '8', Colors.blue),
                    onTap: () {
                      valueBtn('8');
                    },
                  ),
                  GestureDetector(
                      child: const Buttons(
                          Color.fromARGB(66, 82, 82, 82), '9', Colors.blue),
                      onTap: () => valueBtn('9')),
                  GestureDetector(
                      child: const Buttons(Color.fromARGB(66, 82, 82, 82), 'x',
                          Color.fromARGB(173, 53, 173, 53)),
                      onTap: () => valueBtn('x')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      child: const Buttons(
                          Color.fromARGB(66, 82, 82, 82), '4', Colors.blue),
                      onTap: () => valueBtn('4')),
                  GestureDetector(
                      child: const Buttons(
                          Color.fromARGB(66, 82, 82, 82), '5', Colors.blue),
                      onTap: () => valueBtn('5')),
                  GestureDetector(
                      child: const Buttons(
                          Color.fromARGB(66, 82, 82, 82), '6', Colors.blue),
                      onTap: () => valueBtn('6')),
                  GestureDetector(
                      child: const Buttons(Color.fromARGB(66, 82, 82, 82), '-',
                          Color.fromARGB(173, 53, 173, 53)),
                      onTap: () => valueBtn('-')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      child: const Buttons(
                          Color.fromARGB(66, 82, 82, 82), '1', Colors.blue),
                      onTap: () => valueBtn('1')),
                  GestureDetector(
                      child: const Buttons(
                          Color.fromARGB(66, 82, 82, 82), '2', Colors.blue),
                      onTap: () => valueBtn('2')),
                  GestureDetector(
                      child: const Buttons(
                          Color.fromARGB(66, 82, 82, 82), '3', Colors.blue),
                      onTap: () => valueBtn('3')),
                  GestureDetector(
                      child: const Buttons(Color.fromARGB(66, 82, 82, 82), '+',
                          Color.fromARGB(173, 53, 173, 53)),
                      onTap: () => valueBtn('+')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      child: const Buttons(
                          Color.fromARGB(66, 82, 82, 82), '+/-', Colors.blue),
                      onTap: () => valueBtn('+/-')),
                  GestureDetector(
                      child: const Buttons(
                          Color.fromARGB(66, 82, 82, 82), '0', Colors.blue),
                      onTap: () => valueBtn('0')),
                  GestureDetector(
                      child: const Buttons(
                          Color.fromARGB(66, 82, 82, 82), ',', Colors.blue),
                      onTap: () => valueBtn(',')),
                  GestureDetector(
                      child: const Buttons(
                          Color.fromARGB(173, 53, 173, 53), '=', Colors.white),
                      onTap: () => calculate()),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
