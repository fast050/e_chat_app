import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/chat_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FriendCard extends StatelessWidget {
  final String name;
  final String phoneNumber;
  final String? avatarUrl;
  // Replaces the single user avatar, e.g. with a group's stacked avatars.
  final Widget? avatar;
  final Widget? trailing;
  final VoidCallback? onTap;

  const FriendCard({
    super.key,
    required this.name,
    required this.phoneNumber,
    this.avatarUrl,
    this.avatar,
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
      child: Row(
        children: [
          avatar ?? ChatAvatar(name: name, imageUrl: avatarUrl, size: 42.r),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      textStyle.font16Bold.copyWith(color: colors.textPrimary),
                ),
                SizedBox(height: 8.h),
                Text(
                  phoneNumber,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle.font12Bold
                      .copyWith(color: colors.textSecondary),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            SizedBox(width: 8.w),
            trailing,
          ],
        ],
      ),
    );
  }
}
