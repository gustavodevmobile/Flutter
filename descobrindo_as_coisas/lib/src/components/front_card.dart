import 'package:flutter/material.dart';

class FrontCard extends StatefulWidget {
  final String text;
  
  const FrontCard({
    required this.text,
    super.key});

  @override
  State<FrontCard> createState() => _FrontCardState();
}

class _FrontCardState extends State<FrontCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('./assets/images/flowers-8876324_640.png')),
        borderRadius: BorderRadius.circular(10),
      ),
     // child: Center(child: Text(widget.text)),
    );
  }
}
