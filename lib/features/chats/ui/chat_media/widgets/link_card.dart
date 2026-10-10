import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/chat_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LinkCard extends StatelessWidget {
  final String title;
  final String url;
  final String? thumbnailUrl;

  const LinkCard({
    super.key,
    required this.title,
    required this.url,
    this.thumbnailUrl,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colors = Theme.of(context).extension<AppSemanticColors>()!;
    final thumbnailUrl = this.thumbnailUrl;

    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: colors.inputBackground,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          if (thumbnailUrl != null) ...[
            ChatImage(
              url: thumbnailUrl,
              width: 56.r,
              height: 56.r,
              radius: 6.r,
            ),
            SizedBox(width: 12.w),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      textStyle.font16Bold.copyWith(color: colors.textPrimary),
                ),
                SizedBox(height: 6.h),
                Text(
                  url,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle.font12Medium
                      .copyWith(color: colors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
