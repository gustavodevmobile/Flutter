// import 'package:flutter/material.dart';

// void showCarrinhoOverlay(BuildContext context, OverlayEntry? overlayEntry, bool mostrarResumoCarrinho, Function removeCarrinhoOverlay) {
//     if (overlayEntry != null) return;
//     final overlay = Overlay.of(context);
//     overlayEntry = OverlayEntry(
//       builder: (context) => Positioned(
//         top: 100, // ajuste conforme necessário
//         right: 60, // ajuste conforme necessário
//         child: Material(
//           elevation: 4,
//           borderRadius: BorderRadius.circular(8),
//           child: MouseRegion(
//               onEnter: (_) {
//                 setState(() {
//                   mostrarResumoCarrinho = true;
//                 });
//               },
//               onExit: (_) {
//                 setState(() {
//                   mostrarResumoCarrinho = false;
//                   Future.delayed(const Duration(milliseconds: 100), () {
//                     removeCarrinhoOverlay();
//                   });
//                 });
//               },
//               child: BoxCarrinho()),
//         ),
//       ),
//     );
//     overlay.insert(overlayEntry!);
//   }

//   void removeCarrinhoOverlay() {
//     if (!mostrarResumoCarrinho) {
//       _overlayEntry?.remove();
//       _overlayEntry = null;
//     }
//   }