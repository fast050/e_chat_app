import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/core/widgets/clickable_text.dart';
import 'package:e_chat_app/core/widgets/filled_text_button_blue50.dart';
import 'package:e_chat_app/core/widgets/gradient_arrow_button.dart';
import 'package:e_chat_app/features/auth/widgets/otp_input/logic/otp_input_cubit.dart';
import 'package:e_chat_app/features/auth/widgets/otp_input/logic/otp_input_state.dart';
import 'package:e_chat_app/features/auth/widgets/otp_input/widget/otp_input_widget.dart';
import 'package:e_chat_app/core/widgets/time_counter.dart';
import 'package:e_chat_app/features/auth/login/logic/login_otp_step/login_otp_step_cubit.dart';
import 'package:e_chat_app/features/auth/login/logic/login_otp_step/login_otp_step_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginOTPStepView extends StatefulWidget {
  final void Function() onBackNavigation;
  const LoginOTPStepView({super.key, required this.onBackNavigation});

  @override
  State<LoginOTPStepView> createState() => _LoginOTPStepViewState();
}

class _LoginOTPStepViewState extends State<LoginOTPStepView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Use context safely here
      final phoneNumber = context.read<LoginOTPStepCubit>().state.phoneNumber;
      context.read<OTPInputCubit>().sendOTP(phoneNumber: phoneNumber);
    });
  }

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
                      onPressed: () async {
                        //ToDo navigation to the Register Flow
                      },
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
              BlocBuilder<LoginOTPStepCubit, LoginOTPStepState>(
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
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 20.h,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      BlocBuilder<LoginOTPStepCubit, LoginOTPStepState>(
                        builder: (context, state) => TimeCounter(
                          key: ValueKey(state.timerResetRequest),
                          duration: Duration(seconds: 30),
                          style: textStyle.font16Bold
                              .copyWith(color: colorStyleExt.textPrimary),
                          onCountFinish: () => {
                            context
                                .read<LoginOTPStepCubit>()
                                .shouldRequestOTP(false)
                          },
                        ),
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                      BlocBuilder<LoginOTPStepCubit, LoginOTPStepState>(
                        builder: (context, state) => ClickableText(
                          isEnable: state.isRetryOTPEnable,
                          text: "Resend Code",
                          style: textStyle.font16Bold.copyWith(
                            decoration: TextDecoration.underline,
                            color: state.isRetryOTPEnable
                                ? colorStyleExt.textAccent
                                : colorStyleExt.textAccent
                                    .withValues(alpha: .3),
                          ),
                          onTap: () => context
                              .read<LoginOTPStepCubit>()
                              .shouldRequestOTP(true),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  OTPInputWidget(
                    numberOfFields: 6,
                    onVerfiyOTP: (bool isVerify) {
                      context
                          .read<LoginOTPStepCubit>()
                          .performOtpCheck(isVerify);
                    },
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  Align(
                    alignment: AlignmentGeometry.centerRight,
                    child: BlocBuilder<LoginOTPStepCubit, LoginOTPStepState>(
                      builder: (context, state) => GradientArrowButton(
                        onPressed: () {},
                        isClickEnable: state.isValidOTP,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        SizedBox(height: 203.h),
        BlocListener<OTPInputCubit, OTPInputState>(
          listenWhen: (prev, curr) => prev.status != curr.status,
          listener: (context, state) {
            if (state.status == OtpStatus.failed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage)),
              );
            }
          },
          child: const SizedBox.shrink(),
        )
      ],
    );
  }
}
