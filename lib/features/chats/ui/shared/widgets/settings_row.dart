import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// One line of a settings list: icon, label and an optional trailing widget
/// (switch, chevron, swatch).
class SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsRow({
    super.key,
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colors = Theme.of(context).extension<AppSemanticColors>()!;
    final trailing = this.trailing;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        height: 46.h,
        child: Row(
          children: [
            Icon(icon, size: 24.r, color: colors.textPrimary),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textStyle.font16Bold.copyWith(color: colors.textPrimary),
              ),
            ),
            if (trailing != null) ...[
              SizedBox(width: 8.w),
              trailing,
            ],
          ],
        ),
      ),
    );
  }
}
