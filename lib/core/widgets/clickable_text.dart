import 'package:flutter/material.dart';

class ClickableText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final void Function() onTap;
  final bool isEnable;
  const ClickableText({
    super.key,
    required this.text,
    required this.style,
    required this.onTap, 
    required this.isEnable,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isEnable? onTap : null,
      child: Text(
        text,
        style: style,
      ),
    );
  }
}
