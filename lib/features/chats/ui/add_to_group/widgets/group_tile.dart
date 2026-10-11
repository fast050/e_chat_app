import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/features/chats/ui/add_to_group/widgets/group_avatar.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/friend_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A group with an "Add" button that turns into a disabled "Added".
class GroupTile extends StatelessWidget {
  final String name;
  final String subtitle;
  final List<String> avatarUrls;
  final bool isAdded;
  final VoidCallback onAdd;

  const GroupTile({
    super.key,
    required this.name,
    required this.subtitle,
    required this.avatarUrls,
    required this.isAdded,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return FriendCard(
      name: name,
      phoneNumber: subtitle,
      avatar: GroupAvatar(name: name, avatarUrls: avatarUrls, size: 42.r),
      trailing: _AddButton(isAdded: isAdded, onTap: onAdd),
    );
  }
}

class _AddButton extends StatelessWidget {
  final bool isAdded;
  final VoidCallback onTap;

  const _AddButton({required this.isAdded, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colors = Theme.of(context).extension<AppSemanticColors>()!;

    return FilledButton(
      onPressed: isAdded ? null : onTap,
      style: FilledButton.styleFrom(
        backgroundColor: colors.badgeBackground,
        foregroundColor: colors.textOnAccent,
        disabledBackgroundColor: colors.cardBackground,
        disabledForegroundColor: colors.textOnAccent,
        minimumSize: Size(64.w, 32.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: textStyle.font12Bold,
      ),
      child: Text(isAdded ? 'Added' : 'Add'),
    );
  }
}
