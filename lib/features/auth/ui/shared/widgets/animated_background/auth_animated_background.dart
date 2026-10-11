import 'package:flutter/material.dart';

enum CurveSidePosition { start, center, end }

class AuthBackgroundAnimate extends CustomPainter {
  Color? topShapeColor;
  Gradient? bottomShapeGradient;
  Color? bottomShapeColor;
  Gradient? topShapeGradient;
  double? offsetBetweenTopBottom;
  double? animatedValue;
  CurveSidePosition curveSidePosition;

  AuthBackgroundAnimate({
    this.topShapeColor,
    this.bottomShapeColor,
    this.bottomShapeGradient,
    this.topShapeGradient,
    this.offsetBetweenTopBottom,
    this.animatedValue,
    required this.curveSidePosition,
  });

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

    animatedValue = animatedValue ?? 0;

    Path path = getCurvePath(size);

    Path shiftedPath = path.shift(Offset(0, -(offsetBetweenTopBottom ?? 0.0)));

    canvas.drawPath(path, paintBottomShape);
    canvas.drawPath(shiftedPath, paintTopShape);
  }

  Path getCurvePath(Size size) {
    double y1 , quadraticBezierToX1 , quadraticBezierToY2 = 0.0;

    switch (curveSidePosition) {
      case CurveSidePosition.start:
        y1 = size.height * .85 - size.height * .15 * animatedValue!;
        quadraticBezierToX1 = size.width * .40;
        quadraticBezierToY2 = size.height * .70;
        break;

      case CurveSidePosition.center:
        y1 = size.height * .70 - size.height * .15 * animatedValue!;
        quadraticBezierToX1 = size.width / 2;
        quadraticBezierToY2 =
            size.height * .70 - size.height * .15 * animatedValue!;
        break;

      case CurveSidePosition.end:
        y1 = size.height * .70;
        quadraticBezierToX1 = size.width * .60;
        quadraticBezierToY2 =
            size.height * .85 - size.height * .15 * animatedValue!;
        break;
    }

    return Path()
      ..lineTo(0, y1)
      ..quadraticBezierTo(
          quadraticBezierToX1,
          size.height - size.height * .30 * animatedValue!,
          size.width,
          quadraticBezierToY2)
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldRepaint(covariant AuthBackgroundAnimate oldDelegate) {
    return animatedValue == null
        ? false
        : oldDelegate.animatedValue != animatedValue;
  }
}
