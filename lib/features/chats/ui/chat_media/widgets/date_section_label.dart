import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// "Today" / "Yesterday" heading above a group of shared items.
class DateSectionLabel extends StatelessWidget {
  final String label;

  const DateSectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colors = Theme.of(context).extension<AppSemanticColors>()!;

    return Padding(
      padding: EdgeInsets.only(top: 16.h, bottom: 12.h),
      child: Text(
        label,
        style: textStyle.font14Regular.copyWith(color: colors.textTertiary),
      ),
    );
  }
}
