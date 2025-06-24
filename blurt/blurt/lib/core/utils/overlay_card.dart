import 'dart:async';
import 'dart:convert';
import 'package:blurt/widgets/pageview_pre_analise.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

Future<void> showOverlayCard(String usuarioId, String profissionalId ,Map<String, dynamic> usuario,
    {RespostasPreAnalise? preAnalise}) async {
  try {
    await FlutterOverlayWindow.closeOverlay();
    await Future.delayed(const Duration(milliseconds: 300));
    await FlutterOverlayWindow.showOverlay(
      enableDrag: true,
      alignment: OverlayAlignment.center,
      flag: OverlayFlag.defaultFlag,
      overlayTitle: "Blurt",
      positionGravity: PositionGravity.none,
    );
    final respostas = preAnalise?.toMap();
    await FlutterOverlayWindow.shareData(jsonEncode({
      'profissionalId': profissionalId,
      'usuarioId': usuarioId,
      'usuario': usuario,
      'preAnalise': respostas,
    }));
  } catch (e) {
    print('Erro ao mostrar overlay: $e');
  }
}
