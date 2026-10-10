import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/chat_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Large avatar, name and phone number (with a copy button) at the top of the
/// user information screen.
class UserInfoProfile extends StatelessWidget {
  final String name;
  final String? phoneNumber;
  final String? avatarUrl;

  const UserInfoProfile({
    super.key,
    required this.name,
    this.phoneNumber,
    this.avatarUrl,
  });

  Future<void> _copyPhone(BuildContext context, String phoneNumber) async {
    final messenger = ScaffoldMessenger.of(context);
    await Clipboard.setData(ClipboardData(text: phoneNumber));
    messenger
      ..clearSnackBars()
      ..showSnackBar(const SnackBar(content: Text('Phone number copied')));
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colors = Theme.of(context).extension<AppSemanticColors>()!;
    final phoneNumber = this.phoneNumber;

    return Column(
      children: [
        ChatAvatar(
          name: name,
          imageUrl: avatarUrl,
          size: 160.r,
          initialsStyle: textStyle.font40Black,
        ),
        SizedBox(height: 16.h),
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textStyle.font20Medium.copyWith(color: colors.textPrimary),
        ),
        if (phoneNumber != null && phoneNumber.isNotEmpty) ...[
          SizedBox(height: 8.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                phoneNumber,
                style:
                    textStyle.font16Regular.copyWith(color: colors.textPrimary),
              ),
              IconButton(
                tooltip: 'Copy phone number',
                onPressed: () => _copyPhone(context, phoneNumber),
                icon: Icon(
                  Icons.copy_outlined,
                  size: 20.r,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
