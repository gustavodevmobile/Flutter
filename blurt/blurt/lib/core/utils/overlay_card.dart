import 'package:blurt/main.dart';
import 'package:flutter/material.dart';

OverlayEntry? _centralOverlayEntry;

void showCentralOverlay(Widget child,
    {Duration? duration}) {
  final overlay = navigatorKey.currentState?.overlay;
  _centralOverlayEntry = OverlayEntry(
    builder: (context) => Center(child: child,)
    //  Material(
    //   color: Colors.black54, 
    //   child: Center(child: child),
    // ),
  );
  overlay!.insert(_centralOverlayEntry!);
  if (duration != null) {
    Future.delayed(duration, closeCentralOverlay);
  }
}

void closeCentralOverlay() {
  _centralOverlayEntry?.remove();
  _centralOverlayEntry = null;
}
