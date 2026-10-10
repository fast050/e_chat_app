import 'package:e_chat_app/core/helper/extenstions.dart';
import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/colors.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/header_glass_button.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/header_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Header for pushed screens: back button + centered title. Blue by default;
/// [isLight] draws it on the page surface, as the conversation screens do.
class PageHeader extends StatelessWidget {
  final String title;
  final bool isLight;
  final Widget? trailing;

  const PageHeader({
    super.key,
    this.title = '',
    this.isLight = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colors = Theme.of(context).extension<AppSemanticColors>()!;
    final surface = Theme.of(context).colorScheme.surface;
    final foreground = isLight ? colors.textPrimary : colors.textOnAccent;

    final row = Row(
      children: [
        HeaderGlassButton(
          size: 42.r,
          highlightColor: isLight ? surface : AppColors.white20,
          onTap: context.pop,
          child: Icon(Icons.arrow_back, size: 24.r, color: foreground),
        ),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: textStyle.font20Medium.copyWith(color: foreground),
          ),
        ),
        // Balances the back button so the title stays centered.
        trailing ?? SizedBox(width: 42.r),
      ],
    );

    if (!isLight) return HeaderShell(child: row);
    return Container(
      color: surface,
      padding: EdgeInsets.fromLTRB(
        24.w,
        chatsHeaderRowTop(context),
        24.w,
        16.h,
      ),
      child: row,
    );
  }
}
