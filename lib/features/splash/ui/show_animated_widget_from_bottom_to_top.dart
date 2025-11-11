import 'package:flutter/material.dart';

class ShowAnimatedWidgetFromBottomToTop extends StatelessWidget {
  final Duration duration;
  final Widget child;

  const ShowAnimatedWidgetFromBottomToTop({
    super.key,
    required this.child,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: duration,
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, value, _) {
        return ShaderMask(
            shaderCallback: (rect) => LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.white,
                      Colors.transparent
                    ],
                    stops: [
                      value,
                      value,
                    ]).createShader(rect),
            child: child);
      },
      curve: Curves.bounceInOut,
    );
  }
}