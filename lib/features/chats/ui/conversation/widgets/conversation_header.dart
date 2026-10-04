import 'package:e_chat_app/core/helper/extenstions.dart';
import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/friend_card.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/header_glass_button.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/header_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Title row (back, "Message", more) above the other user's card.
class ConversationHeader extends StatelessWidget {
  final String name;
  final String phoneNumber;
  final String? avatarUrl;

  const ConversationHeader({
    super.key,
    required this.name,
    required this.phoneNumber,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colors = Theme.of(context).extension<AppSemanticColors>()!;
    final surface = Theme.of(context).colorScheme.surface;

    return Container(
      color: surface,
      padding: EdgeInsets.fromLTRB(
        24.w,
        chatsHeaderRowTop(context),
        24.w,
        16.h,
      ),
      child: Column(
        children: [
          Row(
            children: [
              HeaderGlassButton(
                size: 42.r,
                highlightColor: surface,
                onTap: context.pop,
                child: Icon(
                  Icons.arrow_back,
                  size: 24.r,
                  color: colors.textPrimary,
                ),
              ),
              Expanded(
                child: Text(
                  'Message',
                  textAlign: TextAlign.center,
                  style: textStyle.font20Medium.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ),
              HeaderGlassButton(
                size: 42.r,
                highlightColor: surface,
                child: Icon(
                  Icons.more_horiz,
                  size: 24.r,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          FriendCard(
            name: name,
            phoneNumber: phoneNumber,
            avatarUrl: avatarUrl,
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
        ],
      ),
    );
  }
}
