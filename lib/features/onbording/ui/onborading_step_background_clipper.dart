import 'package:flutter/material.dart';

class OnBoardingBackgroundClipper extends CustomClipper<Path> {

@override
  Path getClip(Size size) {
    Path path = Path();
    path.quadraticBezierTo(size.width / 2, size.height * .25 , size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
      return true;
  }
} 
