import 'package:flutter_overlay_window/flutter_overlay_window.dart';

void showOverlayFloatBubble() async {
  if (await FlutterOverlayWindow.isPermissionGranted()) {
    await FlutterOverlayWindow.showOverlay(
      height: 150,
      width: 150,
      enableDrag: true,
      alignment: OverlayAlignment.centerLeft,
      flag: OverlayFlag.defaultFlag,
      overlayTitle: "Blurt",
      positionGravity: PositionGravity.auto,
    );
  }
}
