import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/gradients.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradientButton extends StatelessWidget {
  final Function() onPressed;
  final String text;

  const GradientButton(
      {super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).extension<AppTextTheme>()!;

    return Container(
      width: double.infinity,
      height: 60.h,
      decoration: BoxDecoration(
        gradient: AppGradients.lightBlueGradient,
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(text , style: textTheme.font22Black.copyWith(color:
             Theme.of(context).colorScheme.onPrimary
         ),),
      ),
    );
  }
}
