import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/friend_card.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/header_glass_button.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Title row (back, "Message", more) above the other user's card. The more
/// button and the card both open the user's information.
class ConversationHeader extends StatelessWidget {
  final String name;
  final String phoneNumber;
  final String? avatarUrl;
  final VoidCallback? onOpenInfo;

  const ConversationHeader({
    super.key,
    required this.name,
    required this.phoneNumber,
    this.avatarUrl,
    this.onOpenInfo,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppSemanticColors>()!;
    final surface = Theme.of(context).colorScheme.surface;

    return Column(
      children: [
        PageHeader(
          title: 'Message',
          isLight: true,
          trailing: HeaderGlassButton(
            size: 42.r,
            highlightColor: surface,
            onTap: onOpenInfo,
            child: Icon(
              Icons.more_horiz,
              size: 24.r,
              color: colors.textPrimary,
            ),
          ),
        ),
        Container(
          color: surface,
          padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
          child: FriendCard(
            name: name,
            phoneNumber: phoneNumber,
            avatarUrl: avatarUrl,
            onTap: onOpenInfo,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.videocam_outlined,
                  size: 24.r,
                  color: colors.textPrimary,
                ),
                SizedBox(width: 24.w),
                Icon(
                  Icons.call_outlined,
                  size: 24.r,
                  color: colors.textPrimary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
