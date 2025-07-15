import 'package:flutter/material.dart';
import 'dart:html' as html;

class ButtonWhatsapp extends StatefulWidget {
  const ButtonWhatsapp({super.key});

  @override
  State<ButtonWhatsapp> createState() => _ButtonWhatsappState();
}

class _ButtonWhatsappState extends State<ButtonWhatsapp> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = Tween<double>(begin: -0.2, end: 0.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticInOut),
    );
    _startLoop();
  }

  void _startLoop() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) break;
      await _controller.forward();
      await _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 32,
      right: 32,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _animation.value,
            child: child,
          );
        },
        child: GestureDetector(
          onTap: () {
            const url = 'https://wa.me/5513996252021?text=Olá! Preciso de ajuda com meu pedido.';
            html.window.open(url, '_blank');
          },
          child: Image.asset(
            './assets/images/whatsapp_icon.png',
            height: 60,
            width: 60,
          ),
        ),
      ),
    );
  }
}