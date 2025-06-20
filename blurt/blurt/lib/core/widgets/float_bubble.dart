// float_bubble.dart
import 'dart:io';

import 'package:blurt/core/utils/alerta_sonoro.dart';
import 'package:blurt/main.dart';
import 'package:flutter/material.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

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
        if (Platform.isAndroid) {
          // Abre o dashboard do profissional
          const intent = AndroidIntent(
            action: "android.intent.action.MAIN",
            package: 'com.example.blurt', // Substitua pelo seu package name!
            componentName:
                'com.example.blurt.MainActivity', // Substitua também!
            flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
            arguments: <String, dynamic>{
              'abrir_dashboard': true,
            },
          );
          await intent.launch();
        } else {
          await FlutterOverlayWindow.closeOverlay();
          const intent = AndroidIntent(
            action: "android.intent.action.MAIN",
            package: 'com.example.blurt', // Substitua pelo seu package name!
            componentName:
                'com.example.blurt/.MainActivity', // Substitua também!
            flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
            arguments: <String, dynamic>{
              'abrir_dashboard': true,
            },
          );
          await intent.launch();
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
