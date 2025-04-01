import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

// Classe responsável por fazer a animação entre a transição de pages
class Routes {
  // Método que mostra próxima página e remove as demais da pilha
  void popRoutes(BuildContext context, Widget widget) {
    Navigator.pushAndRemoveUntil(
      context,
      PageTransition(
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: 400),
          child: widget),
      (route) => false,
    );
  }


  void pushRoute(BuildContext context, Widget widget) {
    Navigator.push(
      context,
      PageTransition(
          type: PageTransitionType.leftToRight,
          //alignment: Alignment.center,
          duration: const Duration(milliseconds: 700),
          child: widget),
    );
  }

  // void pushRouteFad(BuildContext context, Widget widget) {
  //   Navigator.push(
  //     context,
  //     PageTransition(
  //         type: PageTransitionType.fade,
  //         //alignment: Alignment.center,
  //         duration: const Duration(seconds: 1),
  //         child: widget),
  //   );
  // }

  // void pushRouteRemoveUntilFad(BuildContext context, Widget widget) {
  //   Navigator.pushAndRemoveUntil(
  //       context,
  //       PageTransition(
  //           type: PageTransitionType.fade,
  //           //alignment: Alignment.center,
  //           duration: const Duration(seconds: 1),
  //           child: widget),
  //       (route) => false);
  // }
}
