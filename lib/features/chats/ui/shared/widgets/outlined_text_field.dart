import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 56-high bordered input used by the add friend / create group forms.
class OutlinedTextField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  // Supplies its own horizontal padding.
  final Widget? prefix;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const OutlinedTextField({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.prefix,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colors = Theme.of(context).extension<AppSemanticColors>()!;
    final inputStyle =
        textStyle.font16Regular.copyWith(color: colors.textPrimary);
    final radius = BorderRadius.circular(8.r);

    return TextField(
      onChanged: onChanged,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: inputStyle,
      cursorColor: colors.textPrimaryBrand,
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: inputStyle.copyWith(color: colors.textSecondary),
        prefixIcon: prefix,
        prefixIconConstraints: const BoxConstraints(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: colors.cardBackground),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: colors.badgeBackground, width: 1.5),
        ),
      ),
    );
  }
}
