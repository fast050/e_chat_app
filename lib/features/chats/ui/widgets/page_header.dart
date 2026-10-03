import 'package:e_chat_app/core/helper/extenstions.dart';
import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/features/chats/ui/widgets/header_glass_button.dart';
import 'package:e_chat_app/features/chats/ui/widgets/header_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Header for screens pushed from the chats list: back button + centered title.
class PageHeader extends StatelessWidget {
  final String title;

  const PageHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colors = Theme.of(context).extension<AppSemanticColors>()!;

    return HeaderShell(
      child: Row(
        children: [
          HeaderGlassButton(
            size: 42.r,
            onTap: context.pop,
            child: Icon(
              Icons.arrow_back,
              size: 24.r,
              color: colors.textOnAccent,
            ),
          ),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: textStyle.font20Medium.copyWith(
                color: colors.textOnAccent,
              ),
            ),
          ),
          // Balances the back button so the title stays centered.
          SizedBox(width: 42.r),
        ],
      ),
    );
  }
}
