import 'package:blurt/core/widgets/card_solicitacao_ovelay.dart';
import 'package:blurt/core/widgets/float_bubble.dart';
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
      }
      // if (event == 'parar_som') {
      //   AlertaSonoro.parar();
      // } else {
      //   // Se for dados de solicitação, trate normalmente
      //   setState(() {
      //     dados = jsonDecode(event);
      //   });
      //   AlertaSonoro.tocar();
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (dados == null) {
      return FloatBubble(
        onTap: () async {
          // Aqui pode abrir o app principal, se quiser
        },
      );
    } else {
      return CardSolicitacaoOverlay(
        dados: dados!,
        onAceitar: () {
          //AlertaSonoro.parar();
          setState(() {
            dados = null; // Volta para a bolinha
            AlertaSonoro.parar();
          });
        },
        onRecusar: () async {
          AlertaSonoro.parar();
          setState(() {
            dados = null; // Volta para a bolinha
          });
        },
      );
    }
  }
}
