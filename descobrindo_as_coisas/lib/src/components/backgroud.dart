import 'package:flutter/material.dart';

class Backgroud extends StatelessWidget {
  final Widget child;
  const Backgroud({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromARGB(255, 64, 7, 90),
            const Color.fromARGB(255, 48, 75, 228),
            const Color.fromARGB(255, 64, 7, 90),
          ],
        ),
      ),
      child: child,
    );
  }
}
