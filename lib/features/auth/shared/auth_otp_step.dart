import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/core/widgets/clickable_text.dart';
import 'package:e_chat_app/core/widgets/gradient_arrow_button.dart';
import 'package:e_chat_app/core/widgets/time_counter.dart';
import 'package:e_chat_app/features/auth/shared/logic/auth_otp_step/auth_otp_step_cubit.dart';
import 'package:e_chat_app/features/auth/shared/logic/auth_otp_step/auth_otp_step_state.dart';
import 'package:e_chat_app/features/auth/shared/widgets/otp_input/logic/otp_input_cubit.dart';
import 'package:e_chat_app/features/auth/shared/widgets/otp_input/logic/otp_input_state.dart';
import 'package:e_chat_app/features/auth/shared/widgets/otp_input/widget/otp_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthOTPStep extends StatefulWidget {

  final Function() onNavigation;

  const AuthOTPStep({
    super.key, 
    required this.onNavigation,
  });

  @override
  State<AuthOTPStep> createState() => _AuthOTPStepState();
}

class _AuthOTPStepState extends State<AuthOTPStep> {


   @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Use context safely here
      final phoneNumber = context.read<AuthOTPStepCubit>().state.phoneNumber;
      context.read<OTPInputCubit>().sendOTP(phoneNumber: phoneNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colorStyleExt = Theme.of(context).extension<AppSemanticColors>()!;
    return Column(
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
            BlocBuilder<AuthOTPStepCubit, AuthOTPStepState>(
              builder: (context, state) => TimeCounter(
                key: ValueKey(state.timerResetRequest),
                duration: Duration(seconds: 30),
                style: textStyle.font16Bold
                    .copyWith(color: colorStyleExt.textPrimary),
                onCountFinish: () => {
                  context
                      .read<AuthOTPStepCubit>()
                      .shouldRequestOTP(false)
                },
              ),
            ),
            SizedBox(
              width: 15.w,
            ),
            BlocBuilder<AuthOTPStepCubit, AuthOTPStepState>(
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
                    .read<AuthOTPStepCubit>()
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
                .read<AuthOTPStepCubit>()
                .performOtpCheck(isVerify);
          },
        ),
        SizedBox(
          height: 24.h,
        ),
        Align(
          alignment: AlignmentGeometry.centerRight,
          child: BlocBuilder<AuthOTPStepCubit, AuthOTPStepState>(
            builder: (context, state) => GradientArrowButton(
              onPressed: widget.onNavigation,
              isClickEnable: state.isValidOTP,
            ),
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
