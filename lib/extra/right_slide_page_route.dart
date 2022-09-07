import 'package:flutter/material.dart';

class RightSlideRoute extends PageRouteBuilder {
  final Widget oyna;

  RightSlideRoute(this.oyna)
      : super(
          pageBuilder: (context, animation, anotherAnimation) => oyna,
          transitionDuration: const Duration(milliseconds: 1000),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, boshqaanim, child) {
            animation = CurvedAnimation(
              curve: Curves.fastLinearToSlowEaseIn,
              parent: animation,
              reverseCurve: Curves.fastOutSlowIn,
            );
            return FadeTransition(
              opacity: Tween<double>(begin: 0, end: 1).animate(animation),
              child: oyna,
            );
          },
        );
}
