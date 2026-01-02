import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/core/widgets/gradient_arrow_button.dart';
import 'package:e_chat_app/core/widgets/gradient_checkbox.dart';
import 'package:e_chat_app/core/widgets/filled_text_button_blue50.dart';
import 'package:e_chat_app/core/widgets/phone_input/widget/phone_number_input_widget.dart';
import 'package:e_chat_app/features/login/logic/login_phone_step/login_phone_step_cubit.dart';
import 'package:e_chat_app/features/login/logic/login_phone_step/login_phone_step_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPhoneStepView extends StatelessWidget {
  final void Function(String) onSubmitPhone;
  final void Function() onStepViewNavigate;
  const LoginPhoneStepView(
      {super.key, required this.onSubmitPhone, required this.onStepViewNavigate});

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
                "Enter your\nmoblie phone",
                style: textStyle.font32Medium
                    .copyWith(color: colorStyleExt.textOnPrimary),
                textAlign: TextAlign.start,
              )
            ],
          ),
        ),
        SizedBox(height: 203.h),
        Padding(
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
                      .read<LoginPhoneStepCubit>()
                      .onUpdatePhoneNumberValidation(isValidPhoneNumber);
                },
                onSubmitPhoneNumber: (String phoneNumber) {
                  
                  onSubmitPhone!(phoneNumber);
                  
                  context
                      .read<LoginPhoneStepCubit>()
                      .onSubmitPhoneNumber(phoneNumber);

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
                  BlocBuilder<LoginPhoneStepCubit, LoginPhoneStepState>(
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
        )
      ],
    );
  }
}
