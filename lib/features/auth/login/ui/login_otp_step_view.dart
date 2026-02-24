import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/core/widgets/filled_text_button_blue50.dart';
import 'package:e_chat_app/features/auth/shared/auth_otp_step.dart';
import 'package:e_chat_app/features/auth/shared/logic/auth_otp_step/auth_otp_step_cubit.dart';
import 'package:e_chat_app/features/auth/shared/logic/auth_otp_step/auth_otp_step_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginOTPStepView extends StatelessWidget {
  final void Function() onNavigateScreen;
  final void Function() onRegisterNavigate;

  const LoginOTPStepView({super.key, required this.onNavigateScreen, required this.onRegisterNavigate});

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Login",
                    style: textStyle.font35Bold
                        .copyWith(color: colorStyleExt.textOnPrimary),
                  ),
                  Spacer(),
                  FilledTextButtonBlue50(
                      onPressed: onRegisterNavigate,
                      text: "Register"),
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
              AuthOTPStep( onNavigation: onNavigateScreen)
            ],
          ),
        ),
      ],
    );
  }
}
