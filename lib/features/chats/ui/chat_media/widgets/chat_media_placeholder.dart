import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:flutter/material.dart';

/// Centered note shown by a tab that has nothing to list.
class ChatMediaPlaceholder extends StatelessWidget {
  final String text;

  const ChatMediaPlaceholder({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colors = Theme.of(context).extension<AppSemanticColors>()!;

    return Center(
      child: Text(
        text,
        style: textStyle.font16Medium.copyWith(color: colors.textSecondary),
      ),
    );
  }
}
