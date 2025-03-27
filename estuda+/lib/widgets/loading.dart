import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loading extends StatelessWidget {
  final String? pathAnimation;
  final String? textFeedback;
  const Loading({this.pathAnimation, this.textFeedback, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            pathAnimation ?? './assets/lotties/animation_loading.json',
            width: 200,
            height: 200,
          ),
          Text(
            textFeedback ?? '',
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.indigo),
          ),
        ],
      ),
    );
  }
}
