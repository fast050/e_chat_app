import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/features/chats/ui/widgets/chat_avatar.dart';
import 'package:e_chat_app/features/chats/ui/widgets/unread_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatListTile extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String timeLabel;
  final int unreadCount;
  final String? avatarUrl;
  final VoidCallback? onTap;

  const ChatListTile({
    super.key,
    required this.name,
    required this.lastMessage,
    required this.timeLabel,
    required this.unreadCount,
    this.avatarUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colors = Theme.of(context).extension<AppSemanticColors>()!;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 42.r),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChatAvatar(name: name, imageUrl: avatarUrl, size: 42.r),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle.font16Bold
                        .copyWith(color: colors.textPrimary),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle.font12Bold
                        .copyWith(color: colors.textSecondary),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  timeLabel,
                  style:
                      textStyle.font12Bold.copyWith(color: colors.textTertiary),
                ),
                if (unreadCount > 0) ...[
                  SizedBox(height: 8.h),
                  UnreadBadge(count: unreadCount),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
