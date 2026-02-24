import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/core/widgets/filled_icon_button_blue50.dart';
import 'package:e_chat_app/features/auth/shared/auth_phone_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterPhoneStepView extends StatelessWidget {
  final void Function() onStepViewNavigate;
  final void Function() onLoginNavigate;
  const RegisterPhoneStepView(
      {super.key,
      required this.onStepViewNavigate,
      required this.onLoginNavigate});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colorStyleExt = Theme.of(context).extension<AppSemanticColors>()!;

    return Column(
      children: [
        SizedBox(
          height: 54.h,
        ),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 34.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  FilledIconButtonBlue50(
                    onPressed: onLoginNavigate,
                    text: "Login", 
                    icon: Icon(Icons.arrow_back),
                  ),
                  Spacer(),
                  Text(
                    "Register",
                    style: textStyle.font35Bold
                        .copyWith(color: colorStyleExt.textOnPrimary),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Text(
                "Enter your\nmoblie phone",
                style: textStyle.font32Medium
                    .copyWith(color: colorStyleExt.textOnPrimary),
                textAlign: TextAlign.end,
              )
            ],
          ),
        ),
        SizedBox(height: 203.h),
        AuthPhoneStep(onStepViewNavigate: onStepViewNavigate)
      ],
    );
}

}
