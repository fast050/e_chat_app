import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/core/widgets/filled_icon_button_blue50.dart';
import 'package:e_chat_app/features/auth/shared/auth_otp_step.dart';
import 'package:e_chat_app/features/auth/shared/logic/auth_otp_step/auth_otp_step_cubit.dart';
import 'package:e_chat_app/features/auth/shared/logic/auth_otp_step/auth_otp_step_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterOTPStepView extends StatelessWidget {
  final void Function() onBackNavigation;
  final void Function() onLoginNavigate;
  final void Function() onUserInfoNavigation;

  const RegisterOTPStepView({
    super.key,
    required this.onBackNavigation,
    required this.onLoginNavigate,
    required this.onUserInfoNavigation,
  });

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
                    style: textStyle.font35Bold.copyWith(
                      color: colorStyleExt.textOnPrimary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Text(
                "Enter OTP Code",
                style: textStyle.font32Medium
                    .copyWith(color: colorStyleExt.textOnPrimary),
                textAlign: TextAlign.start,
              ),
              BlocBuilder<AuthOTPStepCubit, AuthOTPStepState>(
                builder: (context, state) => Text(
                  "Sent to : ${state.formatedPhoneNumber ?? ""}",
                  style: textStyle.font20Medium
                      .copyWith(color: colorStyleExt.textOnPrimary),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                height: 133.h,
              ),
              AuthOTPStep(onNavigation: onUserInfoNavigation,)
            ],
          ),
        ),
      ],
    );
  }
}
