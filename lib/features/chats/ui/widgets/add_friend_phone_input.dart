import 'package:country_flags_pro/country_flags_pro.dart';
import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/features/auth/shared/widgets/phone_input/widget/phone_number_formatter.dart';
import 'package:e_chat_app/features/chats/ui/widgets/outlined_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddFriendPhoneInput extends StatelessWidget {
  // ISO country code, e.g. "GB".
  final String countryCode;
  final String dialCode;
  final VoidCallback onCountryTap;
  final ValueChanged<String> onChanged;

  const AddFriendPhoneInput({
    super.key,
    required this.countryCode,
    required this.dialCode,
    required this.onCountryTap,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colors = Theme.of(context).extension<AppSemanticColors>()!;

    return OutlinedTextField(
      hintText: 'Enter Phone Number',
      keyboardType: TextInputType.phone,
      onChanged: onChanged,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(15),
        PhoneNumberFormatter(dialCode: dialCode, code: countryCode),
      ],
      prefix: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 12.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onCountryTap,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CountryFlagsPro.getFlag(
                    countryCode.toLowerCase(),
                    width: 33.w,
                    height: 24.h,
                    fit: BoxFit.fill,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 24.r,
                    color: colors.textPrimary,
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              '($dialCode)',
              style:
                  textStyle.font16Regular.copyWith(color: colors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
