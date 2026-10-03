import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatsAddMenu extends StatelessWidget {
  final VoidCallback onAddFriend;
  final VoidCallback onCreateGroup;

  const ChatsAddMenu({
    super.key,
    required this.onAddFriend,
    required this.onCreateGroup,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 329.w,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(color: Color(0x33000000), blurRadius: 50),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _AddMenuItem(
              iconAsset: 'assets/svgs/user.svg',
              label: 'Add Friend',
              onTap: onAddFriend,
            ),
            SizedBox(height: 16.h),
            _AddMenuItem(
              iconAsset: 'assets/svgs/nav_groups.svg',
              label: 'Create Group',
              onTap: onCreateGroup,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddMenuItem extends StatelessWidget {
  final String iconAsset;
  final String label;
  final VoidCallback onTap;

  const _AddMenuItem({
    required this.iconAsset,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colors = Theme.of(context).extension<AppSemanticColors>()!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6.r),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Row(
          children: [
            SvgPicture.asset(iconAsset, width: 24.r, height: 24.r),
            SizedBox(width: 16.w),
            Text(
              label,
              style: textStyle.font18SemiBold.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
