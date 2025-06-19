// float_bubble.dart
import 'package:blurt/core/utils/alerta_sonoro.dart';
import 'package:flutter/material.dart';

class FloatBubble extends StatefulWidget {
  final VoidCallback? onTap;
  const FloatBubble({this.onTap, super.key});

  @override
  State<FloatBubble> createState() => _FloatBubbleState();
}

class _FloatBubbleState extends State<FloatBubble> {

  @override
  void initState() {
    AlertaSonoro.parar();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.pushNamed(context, '/dashboard_profissional');
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black26)],
        ),
        child: Icon(Icons.chat_bubble, color: Colors.white, size: 40),
      ),
    );
  }
}
