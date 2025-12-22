import 'package:e_chat_app/core/theme/gradients.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GradientArrowButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GradientArrowButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      child: Ink(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppGradients.lightBlueGradient,
        ),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          splashColor: Colors.black.withValues(alpha: .15),
          highlightColor: Colors.black.withValues(alpha: .05),
          child: Center(
            child: SvgPicture.asset(
              "assets/svgs/arrow_right.svg",
              height: 40,
              width: 40,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
