import 'package:e_chat_app/core/helper/extenstions.dart';
import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/core/widgets/filled_icon_button_blue50.dart';
import 'package:e_chat_app/features/auth/register/ui/image_picker_selecter.dart';
import 'package:e_chat_app/features/auth/shared/widgets/app_base_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterUserInformationView extends StatefulWidget {
  const RegisterUserInformationView({super.key});

  @override
  State<RegisterUserInformationView> createState() =>
      _RegisterUserInformationViewState();
}

class _RegisterUserInformationViewState
    extends State<RegisterUserInformationView> {
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
                    context.pop();
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
            AuthBaseTextField(
              hintText: "Your Name",
              prefixIcon: Icon(
                  Icons.person,
                  size: 32.w.h,
                ),
                onChanged: (value) {
                  print(value);
                },
            )
          ],
        ),
      ),
    ]);
  }
}
