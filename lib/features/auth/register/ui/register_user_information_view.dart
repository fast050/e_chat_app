import 'package:e_chat_app/core/helper/extenstions.dart';
import 'package:e_chat_app/core/routing/routes.dart';
import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/core/widgets/filled_icon_button_blue50.dart';
import 'package:e_chat_app/core/widgets/gradient_arrow_button.dart';
import 'package:e_chat_app/features/auth/register/logic/register_user_information_cubit.dart';
import 'package:e_chat_app/features/auth/register/logic/register_user_information_state.dart';
import 'package:e_chat_app/features/auth/register/ui/image_picker_selecter.dart';
import 'package:e_chat_app/features/auth/shared/widgets/app_base_text_field.dart';
import 'package:e_chat_app/features/auth/ui/logic/auth_flow_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterUserInformationView extends StatelessWidget {
  const RegisterUserInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colorTheme = Theme.of(context).extension<AppSemanticColors>()!;

    return Column(children: [
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
                  onPressed: () {
                    context.read<AuthFlowCubit>().backToRegisterOTP();
                  },
                  icon: const Icon(Icons.arrow_back),
                  text: "Login",
                ),
                Spacer(),
                Text(
                  "Register",
                  style: textStyle.font35Bold
                      .copyWith(color: colorTheme.textOnPrimary),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Center(
              child: const ImagePickerSelecter(),
            ),
            SizedBox(
              height: 139.h,
            ),
            TextFieldWithIcon(
              hintText: "Your Name",
              prefixIcon: Icon(
                Icons.person,
                size: 32.w.h,
              ),
              onSubmitted: (value) => context
                  .read<RegisterUserInformationCubit>()
                  .onUpdateUserName(value),
            ),
            SizedBox(
              height: 24.h,
            ),
            GradientArrowButton(
              onPressed: () async {
                final isSubmitted = await context
                    .read<RegisterUserInformationCubit>()
                    .onSubmittedUserInformationData();
                if (isSubmitted) {
                  if (!context.mounted) return;
                  context.pushReplacementNamed(Routes.home);
                }
              },
            ),
            BlocListener<RegisterUserInformationCubit,
                RegisterUserInformationState>(
              listenWhen: (previous, current) =>
                  previous.snackBarEventId != current.snackBarEventId,
              listener: (context, state) {
                if (state.errorMessage == null) return;
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage!),
                  ),
                );
              },
              child: const SizedBox.shrink(),
            )
          ],
        ),
      ),
    ]);
  }
}
