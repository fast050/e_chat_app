import 'package:flutter/material.dart';

class LoginBackgroundAnimate extends CustomPainter {
  final bool shouldAnimate;
  Color? topShapeColor;
  Gradient? bottomShapeGradient;
  Color? bottomShapeColor;
  Gradient? topShapeGradient;
  double? offsetBetweenTopBottom;
  double? animatedValue;
  
  LoginBackgroundAnimate({required this.shouldAnimate , this.topShapeColor , this.bottomShapeColor , this.bottomShapeGradient , this.topShapeGradient, this.offsetBetweenTopBottom , this.animatedValue});

  @override
 @override
void paint(Canvas canvas, Size size) {
  final Rect rect = Offset.zero & size;

  final paintTopShape = Paint()..style = PaintingStyle.fill;
  if (topShapeGradient != null) {
    paintTopShape.shader = topShapeGradient!.createShader(rect);
  } else {
    paintTopShape.color = topShapeColor ?? Colors.transparent;
  }

  final paintBottomShape = Paint()..style = PaintingStyle.fill;
  if (bottomShapeGradient != null) {
    paintBottomShape.shader = bottomShapeGradient!.createShader(rect);
  } else {
    paintBottomShape.color = bottomShapeColor ?? Colors.transparent;
  }

  Path path = Path()
    ..lineTo(0, size.height * .85 - size.height * .15 * animatedValue!)
    ..quadraticBezierTo(
        size.width * .40, size.height - size.height * .30 * animatedValue!, size.width, size.height * .70)
    ..lineTo(size.width, 0)
    ..close();

  Path shiftedPath = path.shift(Offset(0, -(offsetBetweenTopBottom ?? 0.0)));

  canvas.drawPath(path, paintBottomShape);
  canvas.drawPath(shiftedPath, paintTopShape);
}


  @override
  bool shouldRepaint(covariant LoginBackgroundAnimate oldDelegate) {
    return oldDelegate.animatedValue != animatedValue;
  }
}
