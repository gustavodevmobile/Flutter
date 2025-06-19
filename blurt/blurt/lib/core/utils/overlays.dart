import 'package:blurt/core/widgets/card_solicitacao_ovelay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'dart:convert';
import '../utils/alerta_sonoro.dart';

class OverlaySolicitacaoWidget extends StatefulWidget {
  const OverlaySolicitacaoWidget({super.key});

  @override
  State<OverlaySolicitacaoWidget> createState() =>
      _OverlaySolicitacaoWidgetState();
}

class _OverlaySolicitacaoWidgetState extends State<OverlaySolicitacaoWidget> {
  Map<String, dynamic>? dados;

  @override
  void initState() {
    super.initState();
    // Escuta dados compartilhados
    FlutterOverlayWindow.overlayListener.listen((event) {
      if (event != null) {
        setState(() {
          dados = jsonDecode(event);
        });
        //AlertaSonoro.tocar();

        // Fecha após 1 minuto
        Future.delayed(const Duration(minutes: 1), () {
          AlertaSonoro.parar();
          FlutterOverlayWindow.closeOverlay();
        });
      }
    });
  }

  @override
  void dispose() {
    AlertaSonoro.parar();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (dados == null) {
      return const Material(
        color: Colors.transparent,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return CardSolicitacaoOverlay(
      dados: dados!,
      onAceitar: () {
        AlertaSonoro.parar();
        //FlutterOverlayWindow.closeOverlay();
      },
      onRecusar: () {
        AlertaSonoro.parar();
        FlutterOverlayWindow.closeOverlay();
      },
    );
  }
}
