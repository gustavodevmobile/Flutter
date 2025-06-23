//float_bubble.dart
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
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black26)],
          image: DecorationImage(
            image: AssetImage('assets/image/splash.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
