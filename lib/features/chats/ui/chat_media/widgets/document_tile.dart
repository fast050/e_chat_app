import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/colors.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/header_glass_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DocumentTile extends StatelessWidget {
  final String name;
  final String sizeLabel;
  final String extension;
  final bool isDownloaded;
  final VoidCallback onDownload;

  const DocumentTile({
    super.key,
    required this.name,
    required this.sizeLabel,
    required this.extension,
    required this.isDownloaded,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colors = Theme.of(context).extension<AppSemanticColors>()!;

    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: colors.inputBackground,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          _FileTypeBadge(extension: extension),
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
                SizedBox(height: 6.h),
                Text(
                  sizeLabel,
                  style: textStyle.font12Medium
                      .copyWith(color: colors.textSecondary),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          HeaderGlassButton(
            size: 42.r,
            highlightColor: Theme.of(context).colorScheme.surface,
            onTap: isDownloaded ? null : onDownload,
            child: Icon(
              isDownloaded ? Icons.check : Icons.file_download_outlined,
              size: 24.r,
              color: colors.badgeBackground,
            ),
          ),
        ],
      ),
    );
  }
}

class _FileTypeBadge extends StatelessWidget {
  final String extension;

  const _FileTypeBadge({required this.extension});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colors = Theme.of(context).extension<AppSemanticColors>()!;
    final color = switch (extension) {
      'pdf' => AppColors.rose500,
      'doc' || 'docx' => AppColors.orange500,
      'cdr' || 'xls' || 'xlsx' => AppColors.green500,
      'psd' => AppColors.indigo500,
      _ => AppColors.purple500,
    };

    return Container(
      width: 32.w,
      height: 42.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          extension,
          style: textStyle.font12Bold.copyWith(color: colors.textOnAccent),
        ),
      ),
    );
  }
}
