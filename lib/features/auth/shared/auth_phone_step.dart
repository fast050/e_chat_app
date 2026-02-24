import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/core/widgets/gradient_arrow_button.dart';
import 'package:e_chat_app/core/widgets/gradient_checkbox.dart';
import 'package:e_chat_app/features/auth/shared/logic/auth_otp_step/auth_otp_step_cubit.dart';
import 'package:e_chat_app/features/auth/shared/logic/auth_phone_step/auth_phone_step_cubit.dart';
import 'package:e_chat_app/features/auth/shared/logic/auth_phone_step/auth_phone_step_state.dart';
import 'package:e_chat_app/features/auth/shared/widgets/phone_input/widget/phone_number_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthPhoneStep extends StatelessWidget{

  final void Function() onStepViewNavigate;

  const AuthPhoneStep({super.key, required this.onStepViewNavigate});

  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colorStyleExt = Theme.of(context).extension<AppSemanticColors>()!;

    return Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 24.h),
        child: Column(
          children: [
            Text(
              "You will get a code via sms.",
              style: textStyle.font20Regular
                  .copyWith(color: colorStyleExt.textAccent),
            ),
            PhoneNumberInputWidget(
              onPhoneNumberValidationChange: (bool isValidPhoneNumber) {
                context
                    .read<AuthPhoneStepCubit>()
                    .onUpdatePhoneNumberValidation(isValidPhoneNumber);
              },
              onSubmitPhoneNumber: (String phoneNumber) {
                context
                    .read<AuthOTPStepCubit>()
                    .onSubmitPhoneNumber(phoneNumber);
              },
              onSubmitFormatedPhoneNumber: (String formatedPhoneNumber) {
                context
                    .read<AuthOTPStepCubit>()
                    .onSubmitFormatedPhoneNumber(formatedPhoneNumber);
              },
            ),
            SizedBox(
              height: 24.h,
            ),
            Row(
              children: [
                GradientCheckbox(
                  onTap: (isChecked) {
                    // ToDo Use this check value
                  },
                  title: Text(
                    "Remember me",
                    style: textStyle.font16Bold
                        .copyWith(color: colorStyleExt.textPrimary),
                  ),
                ),
                Spacer(),
                BlocBuilder<AuthPhoneStepCubit, AuthPhoneStepState>(
                  builder: (_, state) => GradientArrowButton(
                    isClickEnable: state.isPhoneNumberValid,
                    onPressed:
                        onStepViewNavigate, // navigate internally to StepOtpView
                  ),
                )
              ],
            ),
          ],
        ),
      );
  }
}