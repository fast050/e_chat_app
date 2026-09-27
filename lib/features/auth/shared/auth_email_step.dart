import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/core/widgets/email_text_field.dart';
import 'package:e_chat_app/core/widgets/gradient_arrow_button.dart';
import 'package:e_chat_app/core/widgets/gradient_checkbox.dart';
import 'package:e_chat_app/features/auth/shared/logic/auth_email_step/auth_email_cubit.dart';
import 'package:e_chat_app/features/auth/shared/logic/auth_email_step/auth_email_state.dart';
import 'package:e_chat_app/features/auth/shared/logic/auth_method/auth_method_cubit.dart';
import 'package:e_chat_app/features/auth/shared/logic/auth_method/auth_method_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthEmailStep extends StatelessWidget {
  final void Function() onSubmit;

  const AuthEmailStep({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colorStyleExt = Theme.of(context).extension<AppSemanticColors>()!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.h),
      child: Column(
        children: [
          Text(
            "You will get a login link via email.",
            style: textStyle.font20Regular
                .copyWith(color: colorStyleExt.textAccent),
          ),
          EmailTextField(
            onChanged: ({required email, required isEmailValid}) {
              context
                  .read<AuthMethodCubit>()
                  .onEmailChanged(email: email, isEmailValid: isEmailValid);
            },
          ),
          BlocBuilder<AuthMethodCubit, AuthMethodState>(
            buildWhen: (previous, current) =>
                previous.email != current.email ||
                previous.isEmailValid != current.isEmailValid,
            builder: (context, state) {
              if (state.email.isEmpty || state.isEmailValid) {
                return SizedBox(height: 18.h);
              }
              return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Please enter a valid email",
                  style: textStyle.font16Medium
                      .copyWith(color: colorStyleExt.error),
                ),
              );
            },
          ),
          BlocListener<AuthEmailCubit, AuthEmailState>(
            listenWhen: (previous, current) => previous.error != current.error,
            listener: (context, state) {
              final error = state.error;
              if (error == null) return;
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(SnackBar(content: Text(error.message)));
            },
            child: BlocBuilder<AuthEmailCubit, AuthEmailState>(
              buildWhen: (previous, current) =>
                  previous.linkSent != current.linkSent,
              builder: (context, state) {
                if (!state.linkSent) return SizedBox(height: 12.h);
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Magic link sent — check your email.",
                      style: textStyle.font16Medium
                          .copyWith(color: colorStyleExt.textPrimary),
                    ),
                  ),
                );
              },
            ),
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
              BlocBuilder<AuthMethodCubit, AuthMethodState>(
                buildWhen: (previous, current) =>
                    previous.email != current.email ||
                    previous.isEmailValid != current.isEmailValid,
                builder: (_, methodState) =>
                    BlocBuilder<AuthEmailCubit, AuthEmailState>(
                  buildWhen: (previous, current) =>
                      previous.isSubmitting != current.isSubmitting,
                  builder: (context, emailState) => GradientArrowButton(
                    isClickEnable:
                        methodState.isEmailValid && !emailState.isSubmitting,
                    onPressed: () {
                      context
                          .read<AuthEmailCubit>()
                          .loginWithEmailMigicLink(methodState.email);
                      onSubmit();
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
