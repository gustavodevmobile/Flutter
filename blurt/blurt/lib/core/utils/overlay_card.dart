import 'dart:convert';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

void showOverlayCard(Map<String, dynamic> conteudo) async {
  //await Future.delayed(Duration(milliseconds: 300));
  await FlutterOverlayWindow.showOverlay(
    enableDrag: true,
    alignment: OverlayAlignment.center,
    flag: OverlayFlag.defaultFlag,
    overlayTitle: "Blurt",
    positionGravity: PositionGravity.none,
    
  );
  await FlutterOverlayWindow.shareData(jsonEncode(conteudo));
}
