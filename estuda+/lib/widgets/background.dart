import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('./assets/images/ball-7280265_640.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );

    // Container(
    //   decoration: const BoxDecoration(
    //     gradient: LinearGradient(
    //       begin: Alignment.topLeft,
    //       end: Alignment.bottomRight,
    //       colors: [
    //         Colors.deepPurple,
    //         Colors.indigoAccent,
    //         Colors.indigo,
    //         Colors.indigo,
    //         Colors.deepPurple,
    //       ],
    //     ),
    //   ),
    // );
  }
}
