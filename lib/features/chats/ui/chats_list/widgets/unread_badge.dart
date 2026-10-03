import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UnreadBadge extends StatelessWidget {
  final int count;

  const UnreadBadge({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colors = Theme.of(context).extension<AppSemanticColors>()!;

    return Container(
      constraints: BoxConstraints(minWidth: 16.r),
      padding: EdgeInsets.symmetric(horizontal: 3.r, vertical: 2.r),
      decoration: BoxDecoration(
        color: colors.badgeBackground,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        '$count',
        textAlign: TextAlign.center,
        style: textStyle.font12Bold.copyWith(color: colors.textOnAccent),
      ),
    );
  }
}
