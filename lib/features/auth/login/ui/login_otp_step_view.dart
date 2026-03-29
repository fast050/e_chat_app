import 'package:e_chat_app/core/helper/extenstions.dart';
import 'package:e_chat_app/core/routing/routes.dart';
import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/core/widgets/filled_text_button_blue50.dart';
import 'package:e_chat_app/features/auth/shared/auth_otp_step.dart';
import 'package:e_chat_app/features/auth/shared/logic/auth_otp_step/auth_otp_step_cubit.dart';
import 'package:e_chat_app/features/auth/shared/logic/auth_otp_step/auth_otp_step_state.dart';
import 'package:e_chat_app/features/auth/ui/logic/auth_flow_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginOTPStepView extends StatelessWidget {
  const LoginOTPStepView({super.key});

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
                    onPressed: () =>
                        context.read<AuthFlowCubit>().showRegisterTab(),
                    text: "Register",
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
              AuthOTPStep(
                onNavigation: () => context.pushReplacementNamed(Routes.home),
              )
            ],
          ),
        ),
      ],
    );
  }
}
