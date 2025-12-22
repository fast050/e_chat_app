import 'package:e_chat_app/core/theme/colors.dart';
import 'package:e_chat_app/core/theme/gradients.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradientCheckbox extends StatefulWidget {
  final Widget? title;
  final void Function(bool) onTap;
  const GradientCheckbox({super.key, this.title, required this.onTap});

  @override
  State<GradientCheckbox> createState() => _GradientCheckboxState();
}

class _GradientCheckboxState extends State<GradientCheckbox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<AppSemanticColors>()!;

    return InkWell(
      onTap: () => setState(() {
        isChecked = !isChecked;
        widget.onTap(isChecked);
      }),
      child: Row(children: [
        AnimatedContainer(
          height: 24,
          width: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.r),
            border: isChecked
                ? null
                : Border.all(color: colorTheme.cardBackground, width: 2),
          ),
          duration: Duration(milliseconds: 50),
          child: isChecked
              ? Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                    gradient: AppGradients.lightBlueGradient,
                  ),
                  child: Icon(
                    size: 15,
                    Icons.check,
                    color: AppColors.white,
                  ),
                )
              : null,
        ),
        SizedBox(
          width: 12.h,
        ),
        widget.title != null ? widget.title! : SizedBox()
      ]),
    );
  }
}
