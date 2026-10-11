import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/features/chats/ui/user_info/helper/chat_color_presets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Content of the "Custom Color Chat" bottom sheet. Pops with the ARGB value
/// of the tapped color.
class ChatColorSheet extends StatelessWidget {
  final int? selectedColor;

  const ChatColorSheet({super.key, this.selectedColor});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colors = Theme.of(context).extension<AppSemanticColors>()!;

    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Custom Color Chat',
            style: textStyle.font20Medium.copyWith(color: colors.textPrimary),
          ),
          SizedBox(height: 24.h),
          Wrap(
            spacing: 16.r,
            runSpacing: 16.r,
            children: [
              for (final color in chatColorPresets)
                _ColorSwatch(
                  color: color,
                  isSelected: color.toARGB32() == selectedColor,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  final Color color;
  final bool isSelected;

  const _ColorSwatch({required this.color, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppSemanticColors>()!;

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(color.toARGB32()),
      child: Container(
        width: 48.r,
        height: 48.r,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: isSelected
            ? Icon(Icons.check, size: 24.r, color: colors.textOnAccent)
            : null,
      ),
    );
  }
}
