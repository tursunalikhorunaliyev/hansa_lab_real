import 'package:flutter/material.dart';

class CustomPaintClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path0 = Path();
    path0.moveTo(0, 0);
    path0.lineTo(0, size.height);
    path0.lineTo(size.width * 0.8762500, size.height);
    path0.lineTo(size.width, 0);
    path0.lineTo(0, 0);
    path0.close();
    return path0;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
