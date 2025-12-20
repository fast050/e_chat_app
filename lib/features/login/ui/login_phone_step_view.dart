import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/core/widgets/phone_number/phone_number_input.dart';
import 'package:e_chat_app/core/widgets/filled_text_button_blue50.dart';
import 'package:e_chat_app/features/login/logic/country_code/country_code_cubit.dart';
import 'package:e_chat_app/features/login/logic/country_code/country_code_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPhoneStepView extends StatelessWidget {
  const LoginPhoneStepView({super.key});

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
          padding: EdgeInsetsGeometry.symmetric(horizontal: 24.h),
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
                        FocusScope.of(context).unfocus();
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
        Column(
          children: [
            Text(
              "You will get a code via sms.",
              style: textStyle.font20Regular
                  .copyWith(color: colorStyleExt.textAccent),
            ),
            BlocBuilder<CountryCodeCubit, CountryCodeState>(
                builder: (_, state) {
              if (state.status == CountryStatus.loading) {
                return const CircularProgressIndicator();
              }

              if (state.status == CountryStatus.error) {
                return RefreshIndicator(
                    child: Text("Retry"),
                    onRefresh: () async {
                      context
                          .read<CountryCodeCubit>()
                          .getCountryByDialCode(state.countryCode!.dialCode);
                    });
              }

              return Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 20.w),
                child: PhoneNumberInput(
                    countryCode: state.countryCode!.code.toLowerCase(),
                    dialCode: state.countryCode!.dialCode , 
                    countryName: state.countryCode!.name,
                    onCountryCodeChange: (countryCode) {
                      context.read<CountryCodeCubit>().getCountryByDialCode(countryCode);
                    },
                    ),
              );
            }),
            Checkbox(
              value: true,
              onChanged: (isChecked) {},
              semanticLabel: "Remember me",
            ),
          ],
        )
      ],
    );
  }
}
