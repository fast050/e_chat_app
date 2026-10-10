import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/chat_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final String timeLabel;
  final bool isMine;
  final String? imageUrl;
  // Custom chat color; null keeps the theme's bubble color.
  final Color? bubbleColor;

  const MessageBubble({
    super.key,
    required this.text,
    required this.timeLabel,
    required this.isMine,
    this.imageUrl,
    this.bubbleColor,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colors = Theme.of(context).extension<AppSemanticColors>()!;
    final scheme = Theme.of(context).colorScheme;
    final textColor = isMine ? colors.textOnAccent : colors.textPrimary;
    final timeColor = isMine ? colors.textOnAccent : colors.textSecondary;
    final corner = Radius.circular(12.r);
    // The corner next to the sender's edge is almost square, like a tail.
    final tail = Radius.circular(2.r);
    final imageUrl = this.imageUrl;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 280.w),
        child: Container(
          padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 8.h),
          decoration: BoxDecoration(
            color: bubbleColor ?? (isMine ? scheme.primary : scheme.surface),
            borderRadius: BorderRadius.only(
              topLeft: corner,
              topRight: corner,
              bottomLeft: isMine ? corner : tail,
              bottomRight: isMine ? tail : corner,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (text.isNotEmpty)
                Text(
                  text,
                  style: textStyle.font14Regular.copyWith(color: textColor),
                ),
              if (text.isNotEmpty && imageUrl != null) SizedBox(height: 8.h),
              if (imageUrl != null)
                ChatImage(
                  url: imageUrl,
                  width: 200.w,
                  height: 200.w,
                  radius: 8.r,
                ),
              SizedBox(height: 6.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    timeLabel,
                    style: textStyle.font12Medium.copyWith(color: timeColor),
                  ),
                  if (isMine) ...[
                    SizedBox(width: 6.w),
                    Icon(Icons.done_all, size: 14.r, color: timeColor),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
