import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Buttons extends StatefulWidget {
  final String numbers;
  final Color cor;
  final Color corButton;

  // final String numberBtn;
  const Buttons(this.corButton, this.numbers, this.cor, {super.key});

  @override
  State<Buttons> createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: 80,
        height: 80,
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: widget.corButton,
        ),
        child: Text(
          widget.numbers,
          style: TextStyle(
              fontSize: 30, color: widget.cor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class BackSpace extends StatefulWidget {
  const BackSpace({super.key});

  @override
  State<BackSpace> createState() => _BackSpaceState();
}

class _BackSpaceState extends State<BackSpace> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: const Color.fromARGB(66, 82, 82, 82),
        ),
        child: const Icon(Icons.backspace_sharp, size: 30, color: Colors.white),
      ),
    );
  }
}

class BtnDivide extends StatefulWidget {
  const BtnDivide({super.key});

  @override
  State<BtnDivide> createState() => _BtnDivideState();
}

class _BtnDivideState extends State<BtnDivide> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: const Color.fromARGB(66, 82, 82, 82),
        ),
        child: const Icon(CupertinoIcons.divide, size: 30, color: Color.fromARGB(173, 53, 173, 53)),
    );
  }
}
