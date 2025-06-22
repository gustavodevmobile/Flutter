import 'dart:convert';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

void showOverlayCard(Map<String, dynamic> conteudo) async {
  print('@@@@@@@@@@@@@ 111111111111111111');
  await FlutterOverlayWindow.closeOverlay();
  print('@@@@@@@@@@@@@ 222222222222222222');
  await Future.delayed(
      Duration(milliseconds: 3000) // Aguardando o fechamento do overlay
      );
  print('@@@@@@@@@@@@@ 333333333333333333');
  
  await FlutterOverlayWindow.showOverlay(
    enableDrag: true,
    alignment: OverlayAlignment.center,
    flag: OverlayFlag.defaultFlag,
    overlayTitle: "Blurt",
    positionGravity: PositionGravity.none,
  );
  print('@@@@@@@@@@@@@ 444444444444444444');
  print('Dados recebidos no showOverlayCard: $conteudo');
  await Future.delayed(Duration(milliseconds: 5000));
  await FlutterOverlayWindow.shareData(jsonEncode({
    'type': 'overlay_card',
    'conteudo': conteudo,
  }));
  print('@@@@@@@@@@@@@ 555555555555555555');
}
