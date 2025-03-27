import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Routes {
  void popRoutes(BuildContext context, Widget widget) {
    Navigator.pushAndRemoveUntil(
      context,
      PageTransition(
          type: PageTransitionType.rightToLeft,
          //alignment: Alignment.topRight,
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

  void pushRouteFade(BuildContext context, Widget widget) {
    Navigator.push(
      context,
      PageTransition(
          type: PageTransitionType.fade,
          //alignment: Alignment.center,
          duration: const Duration(seconds: 1),
          child: widget),
    );
  }

  void pushRouteRemoveUntilFade(BuildContext context, Widget widget) {
    Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
            type: PageTransitionType.fade,
            //alignment: Alignment.center,
            duration: const Duration(seconds: 1),
            child: widget),
        (route) => false);
  }
}
