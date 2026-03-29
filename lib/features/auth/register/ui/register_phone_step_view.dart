import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/core/widgets/filled_icon_button_blue50.dart';
import 'package:e_chat_app/core/widgets/gradient_button.dart';
import 'package:e_chat_app/features/auth/login/logic/login_method/login_method_cubit.dart';
import 'package:e_chat_app/features/auth/login/logic/login_method/login_method_state.dart';
import 'package:e_chat_app/features/auth/shared/auth_email_step.dart';
import 'package:e_chat_app/features/auth/shared/auth_phone_step.dart';
import 'package:e_chat_app/features/auth/ui/logic/auth_flow_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterPhoneStepView extends StatelessWidget {
  const RegisterPhoneStepView({super.key});

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
                    onPressed: () =>
                        context.read<AuthFlowCubit>().showLoginTab(),
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
              BlocBuilder<LoginMethodCubit, LoginMethodState>(
                buildWhen: (previous, current) =>
                    previous.loginMethod != current.loginMethod,
                builder: (context, state) => Text(
                  state.loginMethod == LoginMethod.phone
                      ? "Enter your\nmoblie phone"
                      : "Enter your\nemail address",
                  style: textStyle.font32Medium
                      .copyWith(color: colorStyleExt.textOnPrimary),
                  textAlign: TextAlign.end,
                ),
              )
            ],
          ),
        ),
        BlocBuilder<LoginMethodCubit, LoginMethodState>(
          buildWhen: (previous, current) =>
              previous.loginMethod != current.loginMethod,
          builder: (context, state) {
            final isPhoneRegister = state.loginMethod == LoginMethod.phone;
            return Column(
              children: [
                SizedBox(height: 203.h),
                IndexedStack(
                  index: isPhoneRegister ? 0 : 1,
                  children: [
                    AuthPhoneStep(
                      onStepViewNavigate: () =>
                          context.read<AuthFlowCubit>().goToRegisterOTP(),
                    ),
                    AuthEmailStep(onSubmit: () {}),
                  ],
                ),
                SizedBox(height: 24.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.h),
                  child: GradientButton(
                    onPressed: () =>
                        context.read<LoginMethodCubit>().toggleLoginMethod(),
                    text: isPhoneRegister
                        ? "Or Register with Email"
                        : "Or Register with Phone Number",
                  ),
                ),
              ],
            );
          },
        )
      ],
    );
  }
}
